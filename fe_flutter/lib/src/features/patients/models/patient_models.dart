import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:intl/intl.dart';

import '../../../core/serializers.dart';

part 'patient_models.g.dart';

abstract class PatientResponse
    implements Built<PatientResponse, PatientResponseBuilder> {
  BuiltList<Patient> get data;
  MetaData get meta;

  PatientResponse._();
  factory PatientResponse([void Function(PatientResponseBuilder) updates]) =
      _$PatientResponse;

  static Serializer<PatientResponse> get serializer =>
      _$patientResponseSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(PatientResponse.serializer, this)
        as Map<String, dynamic>;
  }

  static PatientResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(PatientResponse.serializer, json);
  }
}

abstract class Patient implements Built<Patient, PatientBuilder> {
  int get id;
  String get documentId;
  String get fullName;
  String get phoneNumber;
  String get createdAt;
  String get updatedAt;
  String get publishedAt;
  String get email;

  @BuiltValueField(wireName: 'DOB')
  String? get dateOfBirth;

  String get heathStatus; // Note: Keeping the typo as it's in the original

  BuiltList<MediaFile>? get chestXray;
  BuiltList<MediaFile>? get skinImage;
  MediaFile? get avatar;

  Patient._();
  factory Patient([void Function(PatientBuilder) updates]) = _$Patient;

  static Serializer<Patient> get serializer => _$patientSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Patient.serializer, this)
        as Map<String, dynamic>;
  }

  static Patient? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Patient.serializer, json);
  }

  // Helper method to format the date of birth
  @BuiltValueField(serialize: false)
  String get formattedDOB {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) {
      return 'Not provided';
    }
    try {
      final date = DateTime.parse(dateOfBirth!);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateOfBirth!;
    }
  }

  // Helper method to get an appropriate color for health status
  static Map<String, Color> get statusColors => {
        'healthy': Colors.green,
        'serious': Colors.orange,
        'fatal': Colors.red,
      };

  Color get healthStatusColor =>
      statusColors[heathStatus.toLowerCase()] ?? Colors.grey;

  String get formattedPhoneNumber {
    // Check if the phone number is not empty
    if (phoneNumber.isEmpty) return "";

    // Remove any non-digit characters if there are any
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If the number already starts with '84', format appropriately
    if (cleanNumber.startsWith('84')) {
      // Format as +84 XX XXX XXXX
      final parts = [
        '(+84)',
        cleanNumber.substring(2, 4),
        cleanNumber.substring(4, 7),
        cleanNumber.substring(7)
      ];
      return parts.join(' ');
    }

    // If the number starts with '0', replace it with '(+84)'
    else if (cleanNumber.startsWith('0')) {
      // Format as +84 XX XXX XXXX
      final parts = [
        '(+84)',
        cleanNumber.substring(1, 3),
        cleanNumber.substring(3, 6),
        cleanNumber.substring(6)
      ];
      return parts.join(' ');
    }

    // Otherwise, just add the country code
    else {
      // Format as +84 XX XXX XXXX (assuming all Vietnamese numbers)
      try {
        final parts = [
          '(+84)',
          cleanNumber.substring(0, 2),
          cleanNumber.substring(2, 5),
          cleanNumber.substring(5)
        ];
        return parts.join(' ');
      } catch (e) {
        // If the number format doesn't match our expectations, just add prefix
        return '+84 $cleanNumber';
      }
    }
  }
}

abstract class MediaFile implements Built<MediaFile, MediaFileBuilder> {
  int get id;
  String get documentId;
  String get name;
  String? get alternativeText;
  String? get caption;
  int get width;
  int get height;
  BuiltMap<String, MediaFormat> get formats;
  String get hash;
  String get ext;
  String get mime;
  double get size;
  String get url;
  String? get previewUrl;
  String get provider;
  String? get providerMetadata;
  String get createdAt;
  String get updatedAt;
  String get publishedAt;

  MediaFile._();
  factory MediaFile([void Function(MediaFileBuilder) updates]) = _$MediaFile;

  static Serializer<MediaFile> get serializer => _$mediaFileSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MediaFile.serializer, this)
        as Map<String, dynamic>;
  }

  static MediaFile? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MediaFile.serializer, json);
  }
}

abstract class MediaFormat implements Built<MediaFormat, MediaFormatBuilder> {
  String get name;
  String get hash;
  String get ext;
  String get mime;
  String? get path;
  int get width;
  int get height;
  double get size;
  int get sizeInBytes;
  String get url;

  MediaFormat._();
  factory MediaFormat([void Function(MediaFormatBuilder) updates]) =
      _$MediaFormat;

  static Serializer<MediaFormat> get serializer => _$mediaFormatSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MediaFormat.serializer, this)
        as Map<String, dynamic>;
  }

  static MediaFormat? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MediaFormat.serializer, json);
  }
}

abstract class MetaData implements Built<MetaData, MetaDataBuilder> {
  Pagination get pagination;

  MetaData._();
  factory MetaData([void Function(MetaDataBuilder) updates]) = _$MetaData;

  static Serializer<MetaData> get serializer => _$metaDataSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MetaData.serializer, this)
        as Map<String, dynamic>;
  }

  static MetaData? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MetaData.serializer, json);
  }
}

abstract class Pagination implements Built<Pagination, PaginationBuilder> {
  int get page;
  int get pageSize;
  int get pageCount;
  int get total;

  Pagination._();
  factory Pagination([void Function(PaginationBuilder) updates]) = _$Pagination;

  static Serializer<Pagination> get serializer => _$paginationSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Pagination.serializer, this)
        as Map<String, dynamic>;
  }

  static Pagination? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Pagination.serializer, json);
  }
}
