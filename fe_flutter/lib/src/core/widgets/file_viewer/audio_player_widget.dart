import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../utils/app_logger.dart';

/// A reusable audio player widget that handles playback from various sources
/// and manages its own state internally.
class AudioPlayerWidget extends StatefulWidget {
  /// Local file path to audio file
  final String? localFilePath;
  
  /// URL to remote audio file
  final String? url;
  
  /// Optional custom title for the player
  final String title;
  
  const AudioPlayerWidget({
    super.key,
    this.localFilePath,
    this.url,
    this.title = 'Audio Recording',
  }) : assert(localFilePath != null || url != null, 
          'Either localFilePath or url must be provided');

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {
  final _logger = AppLogger.getLogger('AudioPlayerWidget');
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Timer? _initRetryTimer;
  int _initAttempts = 0;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Delay audio initialization to ensure the widget is fully built
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _initAudioPlayer();
      }
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause audio when app goes to background
    if (state == AppLifecycleState.paused && _isPlaying) {
      _audioPlayer.pause();
    }
  }

  // Replace the existing _initAudioPlayer() method with these methods

Future<void> _initAudioPlayer() async {
  // Check if widget is still mounted before proceeding
  if (!mounted) {
    _logger.warning('Attempted to initialize player but widget is not mounted');
    return;
  }
  
  // Cancel any previous retry timer
  _initRetryTimer?.cancel();
  
  if (_initAttempts >= 3) {
    _handleAudioError('Failed to initialize audio after multiple attempts');
    return;
  }
  
  _initAttempts++;
  _logger.info('Initializing audio player (attempt $_initAttempts)');
  
  setState(() {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
  });

  try {
    // Release previous listeners and stop playback
    await _releaseResources();
    
    // Create and validate audio source
    final audioSource = await _createAndValidateAudioSource();
    
    // Set up all the event listeners
    _setupAudioSubscriptions();
    
    // Prepare player with the audio source
    await _preparePlayerWithSource(audioSource);
    
  } catch (e, stackTrace) {
    if (!mounted) return; // Check again if widget is still mounted
    
    _logger.severe('Error initializing audio player', e, stackTrace);
    _handleAudioError('Could not load audio file: ${e.toString().replaceAll("Exception: ", "")}');
  }
}

/// Creates and validates the audio source based on provided paths
Future<Source> _createAndValidateAudioSource() async {
  if (widget.localFilePath != null) {
    final file = File(widget.localFilePath!);
    
    if (await file.exists()) {
      _logger.info('Loading audio from file: ${widget.localFilePath}');
      
      // Check file size
      try {
        final fileSize = await file.length();
        _logger.info('Audio file size: $fileSize bytes');
        if (fileSize == 0) {
          throw Exception('Audio file is empty (0 bytes)');
        }
      } catch (e) {
        _logger.warning('Error checking file size: $e');
        // Continue anyway, the player will determine if it's valid
      }
      
      return DeviceFileSource(file.path);
    } else {
      throw Exception('Audio file not found at path: ${widget.localFilePath}');
    }
  } else if (widget.url != null) {
    _logger.info('Loading audio from URL: ${widget.url}');
    return UrlSource(widget.url!);
  } else {
    throw Exception('No audio source provided');
  }
}

/// Sets up all event listeners for the audio player
void _setupAudioSubscriptions() {
  _positionSubscription = _audioPlayer.onPositionChanged.listen(
    (position) {
      if (!mounted) return;
      
      // Ensure position never exceeds duration to prevent slider issues
      final safePosition = _duration > Duration.zero && position > _duration 
          ? _duration 
          : position;
          
      setState(() => _position = safePosition);
    },
    onError: (e) {
      _logger.warning('Error in position stream: $e');
    },
    cancelOnError: false,
  );

  _durationSubscription = _audioPlayer.onDurationChanged.listen(
    (duration) {
      if (!mounted) return;
      _logger.info('Audio loaded successfully with duration: ${duration.inMilliseconds}ms');
      setState(() {
        _duration = duration;
        _hasError = false;
        _errorMessage = null;
        _isLoading = false;
      });
    },
    onError: (e) {
      _logger.warning('Error in duration stream: $e');
    },
    cancelOnError: false,
  );

  _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen(
    (_) async {
      if (!mounted) return;
      _logger.info('Audio playback completed');
      
      // First update the state to show the pause button as play
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
      
      // Prepare for next playback by resetting the source
      try {
        await _audioPlayer.stop();
        
        // Reset source to make it ready for next play
        final audioSource = _createAudioSource();
        await _audioPlayer.setSource(audioSource);
      } catch (e) {
        _logger.warning('Failed to reset audio source after completion: $e');
      }
    },
    onError: (e) {
      _logger.warning('Error in player complete stream: $e');
    },
    cancelOnError: false,
  );

  _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen(
    (state) {
      if (!mounted) return;
      _logger.fine('Player state changed to: $state');
      
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    },
    onError: (e) {
      _logger.warning('Error in player state stream: $e');
    },
    cancelOnError: false,
  );
}

/// Prepares the player with the given audio source
Future<void> _preparePlayerWithSource(Source audioSource) async {
  // Stop any previous playback
  await _audioPlayer.stop();
  
  // Set the source but don't play yet
  await _audioPlayer.setSource(audioSource);
  
  // Start a timeout timer to ensure loading completes
  _startLoadingTimeoutTimer();
}

  // Helper method to create audio source
  Source _createAudioSource() {
    if (widget.localFilePath != null) {
      return DeviceFileSource(widget.localFilePath!);
    } else if (widget.url != null) {
      return UrlSource(widget.url!);
    }
    throw Exception('No audio source available');
  }

  Future<void> _releaseResources() async {
    _cancelSubscriptions();
    
    // Only stop player if it's not in an error state
    try {
      if (_audioPlayer.state != PlayerState.disposed) {
        await _audioPlayer.stop();
      }
    } catch (e) {
      _logger.warning('Error stopping player during resource release: $e');
    }
  }

  void _startLoadingTimeoutTimer() {
    // Set a timeout to check if loading completed
    _initRetryTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _duration == Duration.zero && !_hasError) {
        _logger.warning('Audio loading timeout');
        
        if (_initAttempts < 3) {
          _logger.info('Retrying audio initialization');
          _initAudioPlayer();
        } else {
          _handleAudioError('Audio failed to load after multiple attempts');
        }
      }
    });
  }

  void _handleAudioError(String message) {
    if (!mounted) return;
    
    _logger.warning('Audio error: $message');
    
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _isLoading = false;
      _isPlaying = false;
    });
  }

  Future<void> _playPause() async {
    if (_hasError || _isLoading) return;

    try {
      if (_isPlaying) {
        _logger.info('Pausing audio playback');
        await _audioPlayer.pause();
        
        setState(() {
          _isPlaying = false;
        });
      } else {
        _logger.info('Starting audio playback');
        
        // Create source
        final audioSource = _createAudioSource();
        
        // Check if player is in completed state or at the end
        if (_audioPlayer.state == PlayerState.completed || 
            _position == _duration || 
            _position == Duration.zero) {
            
          _logger.info('Player completed or at start/end position, resetting source');
          
          // Stop current playback
          await _audioPlayer.stop();
          
          // Reset position
          setState(() {
            _position = Duration.zero;
          });
          
          // Set source again to reset the player state
          await _audioPlayer.setSource(audioSource);
          
          // Play from beginning
          await _audioPlayer.resume();
        } else {
          // Normal play from current position
          _logger.info('Resuming from current position: ${_position.inMilliseconds}ms');
          
          // Try resuming first
          await _audioPlayer.resume();
          
          // If resume doesn't work, play with source
          if (_audioPlayer.state != PlayerState.playing) {
            _logger.info('Resume failed, playing with source');
            await _audioPlayer.play(audioSource);
          }
        }
        
        // Verify player is playing
        if (_audioPlayer.state != PlayerState.playing) {
          _logger.warning('Player not playing after play command, state: ${_audioPlayer.state}');
          
          // Last resort: full re-initialization
          _logger.info('Attempting full player reinitialization');
          await _initAudioPlayer();
          
          // Short delay before playing
          await Future.delayed(const Duration(milliseconds: 300));
          await _audioPlayer.play(audioSource);
        }
        
        // Update state manually
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e, stackTrace) {
      // Only handle errors if the widget is still mounted
      if (!mounted) {
        _logger.warning('Error during play/pause but widget is no longer mounted, ignoring: $e');
        return;
      }
      
      _logger.severe('Error during play/pause', e, stackTrace);
      _handleAudioError('Playback error: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  Future<void> _retryPlayback() async {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _initAttempts = 0;  // Reset attempts count
    });
    
    await _initAudioPlayer();
  }

  @override
  void dispose() {
    _logger.info('Disposing audio player');
    
    // Cancel the init retry timer first
    _initRetryTimer?.cancel();
    
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Cancel all subscriptions safely
    _cancelSubscriptions();
    
    // Safe disposal with try-catch to prevent uncaught exceptions
    try {
      // Stop playback first, then dispose
      _audioPlayer.stop().then((_) {
        _audioPlayer.dispose();
      }).catchError((e) {
        _logger.warning('Error stopping audio player during disposal: $e');
        // Still try to dispose even if stop fails
        _audioPlayer.dispose();
      });
    } catch (e) {
      _logger.severe('Error disposing audio player: $e');
    }
    
    super.dispose();
  }

  // Helper for safer subscription cancellation
  void _cancelSubscriptions() {
    try {
      // Use try-catch for each subscription to ensure all get cancelled
      try { _positionSubscription?.cancel(); } 
      catch (e) { _logger.warning('Error cancelling position subscription: $e'); }
      
      try { _durationSubscription?.cancel(); } 
      catch (e) { _logger.warning('Error cancelling duration subscription: $e'); }
      
      try { _playerCompleteSubscription?.cancel(); } 
      catch (e) { _logger.warning('Error cancelling player complete subscription: $e'); }
      
      try { _playerStateSubscription?.cancel(); } 
      catch (e) { _logger.warning('Error cancelling player state subscription: $e'); }
    } finally {
      // Clear all subscriptions
      _positionSubscription = null;
      _durationSubscription = null;
      _playerCompleteSubscription = null;
      _playerStateSubscription = null;
    }
  }

  String _formatDuration(Duration duration) {
    // Make sure duration is non-negative
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(safeDuration.inMinutes.remainder(60));
    final seconds = twoDigits(safeDuration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Row(
            children: [
              Icon(
                Icons.audio_file,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_hasError) ...[
            // Error message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage ?? 'Could not play audio',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: FilledButton.tonal(
                      onPressed: _retryPlayback,
                      child: const Text('Try Again'),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Always show controls, with loading indicator only during initial loading
            Row(
              children: [
                // Play/Pause button with loading indicator when needed
                _isLoading && _duration == Duration.zero 
                    ? const SizedBox(
                        width: 32,
                        height: 32,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _isLoading ? null : _playPause,
                        color: colorScheme.primary,
                        iconSize: 32,
                        padding: EdgeInsets.zero,
                      ),
                const SizedBox(width: 16),
                
                // Progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 4,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                          trackShape: RoundedRectSliderTrackShape(),
                        ),
                        child: Slider(
                          // Ensure the value stays within bounds by using min() to prevent exceeding max
                          value: _duration.inMilliseconds > 0 
                              ? math.min(_position.inMilliseconds.toDouble(), _duration.inMilliseconds.toDouble())
                              : 0.0,
                          min: 0.0,
                          max: _duration.inMilliseconds > 0 
                              ? _duration.inMilliseconds.toDouble()
                              : 1.0,
                          onChanged: (_isLoading && _duration == Duration.zero) ? null : (value) {
                            final newPosition = Duration(milliseconds: value.round());
                            _audioPlayer.seek(newPosition);
                            setState(() {
                              _position = newPosition;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              _formatDuration(_duration),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}