// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PatientResponse> _$patientResponseSerializer =
    new _$PatientResponseSerializer();
Serializer<Patient> _$patientSerializer = new _$PatientSerializer();
Serializer<MediaFile> _$mediaFileSerializer = new _$MediaFileSerializer();
Serializer<MediaFormat> _$mediaFormatSerializer = new _$MediaFormatSerializer();
Serializer<MetaData> _$metaDataSerializer = new _$MetaDataSerializer();
Serializer<Pagination> _$paginationSerializer = new _$PaginationSerializer();

class _$PatientResponseSerializer
    implements StructuredSerializer<PatientResponse> {
  @override
  final Iterable<Type> types = const [PatientResponse, _$PatientResponse];
  @override
  final String wireName = 'PatientResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PatientResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Patient)])),
      'meta',
      serializers.serialize(object.meta,
          specifiedType: const FullType(MetaData)),
    ];

    return result;
  }

  @override
  PatientResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PatientResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Patient)]))!
              as BuiltList<Object?>);
          break;
        case 'meta':
          result.meta.replace(serializers.deserialize(value,
              specifiedType: const FullType(MetaData))! as MetaData);
          break;
      }
    }

    return result.build();
  }
}

class _$PatientSerializer implements StructuredSerializer<Patient> {
  @override
  final Iterable<Type> types = const [Patient, _$Patient];
  @override
  final String wireName = 'Patient';

  @override
  Iterable<Object?> serialize(Serializers serializers, Patient object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'documentId',
      serializers.serialize(object.documentId,
          specifiedType: const FullType(String)),
      'fullName',
      serializers.serialize(object.fullName,
          specifiedType: const FullType(String)),
      'phoneNumber',
      serializers.serialize(object.phoneNumber,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'publishedAt',
      serializers.serialize(object.publishedAt,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'heathStatus',
      serializers.serialize(object.heathStatus,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.dateOfBirth;
    if (value != null) {
      result
        ..add('DOB')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.chestXray;
    if (value != null) {
      result
        ..add('chestXray')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(MediaFile)])));
    }
    value = object.skinImage;
    if (value != null) {
      result
        ..add('skinImage')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(MediaFile)])));
    }
    value = object.avatar;
    if (value != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(MediaFile)));
    }
    return result;
  }

  @override
  Patient deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PatientBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'documentId':
          result.documentId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'fullName':
          result.fullName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'publishedAt':
          result.publishedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'DOB':
          result.dateOfBirth = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'heathStatus':
          result.heathStatus = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'chestXray':
          result.chestXray.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(MediaFile)]))!
              as BuiltList<Object?>);
          break;
        case 'skinImage':
          result.skinImage.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(MediaFile)]))!
              as BuiltList<Object?>);
          break;
        case 'avatar':
          result.avatar.replace(serializers.deserialize(value,
              specifiedType: const FullType(MediaFile))! as MediaFile);
          break;
      }
    }

    return result.build();
  }
}

class _$MediaFileSerializer implements StructuredSerializer<MediaFile> {
  @override
  final Iterable<Type> types = const [MediaFile, _$MediaFile];
  @override
  final String wireName = 'MediaFile';

  @override
  Iterable<Object?> serialize(Serializers serializers, MediaFile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'documentId',
      serializers.serialize(object.documentId,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'width',
      serializers.serialize(object.width, specifiedType: const FullType(int)),
      'height',
      serializers.serialize(object.height, specifiedType: const FullType(int)),
      'formats',
      serializers.serialize(object.formats,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(MediaFormat)])),
      'hash',
      serializers.serialize(object.hash, specifiedType: const FullType(String)),
      'ext',
      serializers.serialize(object.ext, specifiedType: const FullType(String)),
      'mime',
      serializers.serialize(object.mime, specifiedType: const FullType(String)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(double)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
      'provider',
      serializers.serialize(object.provider,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'publishedAt',
      serializers.serialize(object.publishedAt,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.alternativeText;
    if (value != null) {
      result
        ..add('alternativeText')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.caption;
    if (value != null) {
      result
        ..add('caption')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.previewUrl;
    if (value != null) {
      result
        ..add('previewUrl')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.providerMetadata;
    if (value != null) {
      result
        ..add('providerMetadata')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  MediaFile deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MediaFileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'documentId':
          result.documentId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'alternativeText':
          result.alternativeText = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'caption':
          result.caption = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'formats':
          result.formats.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(MediaFormat)
              ]))!);
          break;
        case 'hash':
          result.hash = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'ext':
          result.ext = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'mime':
          result.mime = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'previewUrl':
          result.previewUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'provider':
          result.provider = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'providerMetadata':
          result.providerMetadata = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'publishedAt':
          result.publishedAt = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MediaFormatSerializer implements StructuredSerializer<MediaFormat> {
  @override
  final Iterable<Type> types = const [MediaFormat, _$MediaFormat];
  @override
  final String wireName = 'MediaFormat';

  @override
  Iterable<Object?> serialize(Serializers serializers, MediaFormat object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'hash',
      serializers.serialize(object.hash, specifiedType: const FullType(String)),
      'ext',
      serializers.serialize(object.ext, specifiedType: const FullType(String)),
      'mime',
      serializers.serialize(object.mime, specifiedType: const FullType(String)),
      'width',
      serializers.serialize(object.width, specifiedType: const FullType(int)),
      'height',
      serializers.serialize(object.height, specifiedType: const FullType(int)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(double)),
      'sizeInBytes',
      serializers.serialize(object.sizeInBytes,
          specifiedType: const FullType(int)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.path;
    if (value != null) {
      result
        ..add('path')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  MediaFormat deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MediaFormatBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'hash':
          result.hash = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'ext':
          result.ext = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'mime':
          result.mime = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'path':
          result.path = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'sizeInBytes':
          result.sizeInBytes = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MetaDataSerializer implements StructuredSerializer<MetaData> {
  @override
  final Iterable<Type> types = const [MetaData, _$MetaData];
  @override
  final String wireName = 'MetaData';

  @override
  Iterable<Object?> serialize(Serializers serializers, MetaData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'pagination',
      serializers.serialize(object.pagination,
          specifiedType: const FullType(Pagination)),
    ];

    return result;
  }

  @override
  MetaData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MetaDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'pagination':
          result.pagination.replace(serializers.deserialize(value,
              specifiedType: const FullType(Pagination))! as Pagination);
          break;
      }
    }

    return result.build();
  }
}

class _$PaginationSerializer implements StructuredSerializer<Pagination> {
  @override
  final Iterable<Type> types = const [Pagination, _$Pagination];
  @override
  final String wireName = 'Pagination';

  @override
  Iterable<Object?> serialize(Serializers serializers, Pagination object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'page',
      serializers.serialize(object.page, specifiedType: const FullType(int)),
      'pageSize',
      serializers.serialize(object.pageSize,
          specifiedType: const FullType(int)),
      'pageCount',
      serializers.serialize(object.pageCount,
          specifiedType: const FullType(int)),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Pagination deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaginationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'page':
          result.page = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'pageSize':
          result.pageSize = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'pageCount':
          result.pageCount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$PatientResponse extends PatientResponse {
  @override
  final BuiltList<Patient> data;
  @override
  final MetaData meta;

  factory _$PatientResponse([void Function(PatientResponseBuilder)? updates]) =>
      (new PatientResponseBuilder()..update(updates))._build();

  _$PatientResponse._({required this.data, required this.meta}) : super._() {
    BuiltValueNullFieldError.checkNotNull(data, r'PatientResponse', 'data');
    BuiltValueNullFieldError.checkNotNull(meta, r'PatientResponse', 'meta');
  }

  @override
  PatientResponse rebuild(void Function(PatientResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatientResponseBuilder toBuilder() =>
      new PatientResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatientResponse && data == other.data && meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatientResponse')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PatientResponseBuilder
    implements Builder<PatientResponse, PatientResponseBuilder> {
  _$PatientResponse? _$v;

  ListBuilder<Patient>? _data;
  ListBuilder<Patient> get data => _$this._data ??= new ListBuilder<Patient>();
  set data(ListBuilder<Patient>? data) => _$this._data = data;

  MetaDataBuilder? _meta;
  MetaDataBuilder get meta => _$this._meta ??= new MetaDataBuilder();
  set meta(MetaDataBuilder? meta) => _$this._meta = meta;

  PatientResponseBuilder();

  PatientResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatientResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PatientResponse;
  }

  @override
  void update(void Function(PatientResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatientResponse build() => _build();

  _$PatientResponse _build() {
    _$PatientResponse _$result;
    try {
      _$result = _$v ??
          new _$PatientResponse._(
            data: data.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PatientResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Patient extends Patient {
  @override
  final int id;
  @override
  final String documentId;
  @override
  final String fullName;
  @override
  final String phoneNumber;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String publishedAt;
  @override
  final String email;
  @override
  final String? dateOfBirth;
  @override
  final String heathStatus;
  @override
  final BuiltList<MediaFile>? chestXray;
  @override
  final BuiltList<MediaFile>? skinImage;
  @override
  final MediaFile? avatar;

  factory _$Patient([void Function(PatientBuilder)? updates]) =>
      (new PatientBuilder()..update(updates))._build();

  _$Patient._(
      {required this.id,
      required this.documentId,
      required this.fullName,
      required this.phoneNumber,
      required this.createdAt,
      required this.updatedAt,
      required this.publishedAt,
      required this.email,
      this.dateOfBirth,
      required this.heathStatus,
      this.chestXray,
      this.skinImage,
      this.avatar})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Patient', 'id');
    BuiltValueNullFieldError.checkNotNull(documentId, r'Patient', 'documentId');
    BuiltValueNullFieldError.checkNotNull(fullName, r'Patient', 'fullName');
    BuiltValueNullFieldError.checkNotNull(
        phoneNumber, r'Patient', 'phoneNumber');
    BuiltValueNullFieldError.checkNotNull(createdAt, r'Patient', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, r'Patient', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        publishedAt, r'Patient', 'publishedAt');
    BuiltValueNullFieldError.checkNotNull(email, r'Patient', 'email');
    BuiltValueNullFieldError.checkNotNull(
        heathStatus, r'Patient', 'heathStatus');
  }

  @override
  Patient rebuild(void Function(PatientBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatientBuilder toBuilder() => new PatientBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Patient &&
        id == other.id &&
        documentId == other.documentId &&
        fullName == other.fullName &&
        phoneNumber == other.phoneNumber &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        publishedAt == other.publishedAt &&
        email == other.email &&
        dateOfBirth == other.dateOfBirth &&
        heathStatus == other.heathStatus &&
        chestXray == other.chestXray &&
        skinImage == other.skinImage &&
        avatar == other.avatar;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, documentId.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, dateOfBirth.hashCode);
    _$hash = $jc(_$hash, heathStatus.hashCode);
    _$hash = $jc(_$hash, chestXray.hashCode);
    _$hash = $jc(_$hash, skinImage.hashCode);
    _$hash = $jc(_$hash, avatar.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Patient')
          ..add('id', id)
          ..add('documentId', documentId)
          ..add('fullName', fullName)
          ..add('phoneNumber', phoneNumber)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('publishedAt', publishedAt)
          ..add('email', email)
          ..add('dateOfBirth', dateOfBirth)
          ..add('heathStatus', heathStatus)
          ..add('chestXray', chestXray)
          ..add('skinImage', skinImage)
          ..add('avatar', avatar))
        .toString();
  }
}

class PatientBuilder implements Builder<Patient, PatientBuilder> {
  _$Patient? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _documentId;
  String? get documentId => _$this._documentId;
  set documentId(String? documentId) => _$this._documentId = documentId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _publishedAt;
  String? get publishedAt => _$this._publishedAt;
  set publishedAt(String? publishedAt) => _$this._publishedAt = publishedAt;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _dateOfBirth;
  String? get dateOfBirth => _$this._dateOfBirth;
  set dateOfBirth(String? dateOfBirth) => _$this._dateOfBirth = dateOfBirth;

  String? _heathStatus;
  String? get heathStatus => _$this._heathStatus;
  set heathStatus(String? heathStatus) => _$this._heathStatus = heathStatus;

  ListBuilder<MediaFile>? _chestXray;
  ListBuilder<MediaFile> get chestXray =>
      _$this._chestXray ??= new ListBuilder<MediaFile>();
  set chestXray(ListBuilder<MediaFile>? chestXray) =>
      _$this._chestXray = chestXray;

  ListBuilder<MediaFile>? _skinImage;
  ListBuilder<MediaFile> get skinImage =>
      _$this._skinImage ??= new ListBuilder<MediaFile>();
  set skinImage(ListBuilder<MediaFile>? skinImage) =>
      _$this._skinImage = skinImage;

  MediaFileBuilder? _avatar;
  MediaFileBuilder get avatar => _$this._avatar ??= new MediaFileBuilder();
  set avatar(MediaFileBuilder? avatar) => _$this._avatar = avatar;

  PatientBuilder();

  PatientBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _documentId = $v.documentId;
      _fullName = $v.fullName;
      _phoneNumber = $v.phoneNumber;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _publishedAt = $v.publishedAt;
      _email = $v.email;
      _dateOfBirth = $v.dateOfBirth;
      _heathStatus = $v.heathStatus;
      _chestXray = $v.chestXray?.toBuilder();
      _skinImage = $v.skinImage?.toBuilder();
      _avatar = $v.avatar?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Patient other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Patient;
  }

  @override
  void update(void Function(PatientBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Patient build() => _build();

  _$Patient _build() {
    _$Patient _$result;
    try {
      _$result = _$v ??
          new _$Patient._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Patient', 'id'),
            documentId: BuiltValueNullFieldError.checkNotNull(
                documentId, r'Patient', 'documentId'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'Patient', 'fullName'),
            phoneNumber: BuiltValueNullFieldError.checkNotNull(
                phoneNumber, r'Patient', 'phoneNumber'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'Patient', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'Patient', 'updatedAt'),
            publishedAt: BuiltValueNullFieldError.checkNotNull(
                publishedAt, r'Patient', 'publishedAt'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'Patient', 'email'),
            dateOfBirth: dateOfBirth,
            heathStatus: BuiltValueNullFieldError.checkNotNull(
                heathStatus, r'Patient', 'heathStatus'),
            chestXray: _chestXray?.build(),
            skinImage: _skinImage?.build(),
            avatar: _avatar?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'chestXray';
        _chestXray?.build();
        _$failedField = 'skinImage';
        _skinImage?.build();
        _$failedField = 'avatar';
        _avatar?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Patient', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$MediaFile extends MediaFile {
  @override
  final int id;
  @override
  final String documentId;
  @override
  final String name;
  @override
  final String? alternativeText;
  @override
  final String? caption;
  @override
  final int width;
  @override
  final int height;
  @override
  final BuiltMap<String, MediaFormat> formats;
  @override
  final String hash;
  @override
  final String ext;
  @override
  final String mime;
  @override
  final double size;
  @override
  final String url;
  @override
  final String? previewUrl;
  @override
  final String provider;
  @override
  final String? providerMetadata;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String publishedAt;

  factory _$MediaFile([void Function(MediaFileBuilder)? updates]) =>
      (new MediaFileBuilder()..update(updates))._build();

  _$MediaFile._(
      {required this.id,
      required this.documentId,
      required this.name,
      this.alternativeText,
      this.caption,
      required this.width,
      required this.height,
      required this.formats,
      required this.hash,
      required this.ext,
      required this.mime,
      required this.size,
      required this.url,
      this.previewUrl,
      required this.provider,
      this.providerMetadata,
      required this.createdAt,
      required this.updatedAt,
      required this.publishedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'MediaFile', 'id');
    BuiltValueNullFieldError.checkNotNull(
        documentId, r'MediaFile', 'documentId');
    BuiltValueNullFieldError.checkNotNull(name, r'MediaFile', 'name');
    BuiltValueNullFieldError.checkNotNull(width, r'MediaFile', 'width');
    BuiltValueNullFieldError.checkNotNull(height, r'MediaFile', 'height');
    BuiltValueNullFieldError.checkNotNull(formats, r'MediaFile', 'formats');
    BuiltValueNullFieldError.checkNotNull(hash, r'MediaFile', 'hash');
    BuiltValueNullFieldError.checkNotNull(ext, r'MediaFile', 'ext');
    BuiltValueNullFieldError.checkNotNull(mime, r'MediaFile', 'mime');
    BuiltValueNullFieldError.checkNotNull(size, r'MediaFile', 'size');
    BuiltValueNullFieldError.checkNotNull(url, r'MediaFile', 'url');
    BuiltValueNullFieldError.checkNotNull(provider, r'MediaFile', 'provider');
    BuiltValueNullFieldError.checkNotNull(createdAt, r'MediaFile', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, r'MediaFile', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        publishedAt, r'MediaFile', 'publishedAt');
  }

  @override
  MediaFile rebuild(void Function(MediaFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaFileBuilder toBuilder() => new MediaFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaFile &&
        id == other.id &&
        documentId == other.documentId &&
        name == other.name &&
        alternativeText == other.alternativeText &&
        caption == other.caption &&
        width == other.width &&
        height == other.height &&
        formats == other.formats &&
        hash == other.hash &&
        ext == other.ext &&
        mime == other.mime &&
        size == other.size &&
        url == other.url &&
        previewUrl == other.previewUrl &&
        provider == other.provider &&
        providerMetadata == other.providerMetadata &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        publishedAt == other.publishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, documentId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, alternativeText.hashCode);
    _$hash = $jc(_$hash, caption.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, formats.hashCode);
    _$hash = $jc(_$hash, hash.hashCode);
    _$hash = $jc(_$hash, ext.hashCode);
    _$hash = $jc(_$hash, mime.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, previewUrl.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, providerMetadata.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaFile')
          ..add('id', id)
          ..add('documentId', documentId)
          ..add('name', name)
          ..add('alternativeText', alternativeText)
          ..add('caption', caption)
          ..add('width', width)
          ..add('height', height)
          ..add('formats', formats)
          ..add('hash', hash)
          ..add('ext', ext)
          ..add('mime', mime)
          ..add('size', size)
          ..add('url', url)
          ..add('previewUrl', previewUrl)
          ..add('provider', provider)
          ..add('providerMetadata', providerMetadata)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('publishedAt', publishedAt))
        .toString();
  }
}

class MediaFileBuilder implements Builder<MediaFile, MediaFileBuilder> {
  _$MediaFile? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _documentId;
  String? get documentId => _$this._documentId;
  set documentId(String? documentId) => _$this._documentId = documentId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _alternativeText;
  String? get alternativeText => _$this._alternativeText;
  set alternativeText(String? alternativeText) =>
      _$this._alternativeText = alternativeText;

  String? _caption;
  String? get caption => _$this._caption;
  set caption(String? caption) => _$this._caption = caption;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  MapBuilder<String, MediaFormat>? _formats;
  MapBuilder<String, MediaFormat> get formats =>
      _$this._formats ??= new MapBuilder<String, MediaFormat>();
  set formats(MapBuilder<String, MediaFormat>? formats) =>
      _$this._formats = formats;

  String? _hash;
  String? get hash => _$this._hash;
  set hash(String? hash) => _$this._hash = hash;

  String? _ext;
  String? get ext => _$this._ext;
  set ext(String? ext) => _$this._ext = ext;

  String? _mime;
  String? get mime => _$this._mime;
  set mime(String? mime) => _$this._mime = mime;

  double? _size;
  double? get size => _$this._size;
  set size(double? size) => _$this._size = size;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _previewUrl;
  String? get previewUrl => _$this._previewUrl;
  set previewUrl(String? previewUrl) => _$this._previewUrl = previewUrl;

  String? _provider;
  String? get provider => _$this._provider;
  set provider(String? provider) => _$this._provider = provider;

  String? _providerMetadata;
  String? get providerMetadata => _$this._providerMetadata;
  set providerMetadata(String? providerMetadata) =>
      _$this._providerMetadata = providerMetadata;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _publishedAt;
  String? get publishedAt => _$this._publishedAt;
  set publishedAt(String? publishedAt) => _$this._publishedAt = publishedAt;

  MediaFileBuilder();

  MediaFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _documentId = $v.documentId;
      _name = $v.name;
      _alternativeText = $v.alternativeText;
      _caption = $v.caption;
      _width = $v.width;
      _height = $v.height;
      _formats = $v.formats.toBuilder();
      _hash = $v.hash;
      _ext = $v.ext;
      _mime = $v.mime;
      _size = $v.size;
      _url = $v.url;
      _previewUrl = $v.previewUrl;
      _provider = $v.provider;
      _providerMetadata = $v.providerMetadata;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _publishedAt = $v.publishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaFile other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MediaFile;
  }

  @override
  void update(void Function(MediaFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaFile build() => _build();

  _$MediaFile _build() {
    _$MediaFile _$result;
    try {
      _$result = _$v ??
          new _$MediaFile._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'MediaFile', 'id'),
            documentId: BuiltValueNullFieldError.checkNotNull(
                documentId, r'MediaFile', 'documentId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'MediaFile', 'name'),
            alternativeText: alternativeText,
            caption: caption,
            width: BuiltValueNullFieldError.checkNotNull(
                width, r'MediaFile', 'width'),
            height: BuiltValueNullFieldError.checkNotNull(
                height, r'MediaFile', 'height'),
            formats: formats.build(),
            hash: BuiltValueNullFieldError.checkNotNull(
                hash, r'MediaFile', 'hash'),
            ext:
                BuiltValueNullFieldError.checkNotNull(ext, r'MediaFile', 'ext'),
            mime: BuiltValueNullFieldError.checkNotNull(
                mime, r'MediaFile', 'mime'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, r'MediaFile', 'size'),
            url:
                BuiltValueNullFieldError.checkNotNull(url, r'MediaFile', 'url'),
            previewUrl: previewUrl,
            provider: BuiltValueNullFieldError.checkNotNull(
                provider, r'MediaFile', 'provider'),
            providerMetadata: providerMetadata,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'MediaFile', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'MediaFile', 'updatedAt'),
            publishedAt: BuiltValueNullFieldError.checkNotNull(
                publishedAt, r'MediaFile', 'publishedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'formats';
        formats.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'MediaFile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$MediaFormat extends MediaFormat {
  @override
  final String name;
  @override
  final String hash;
  @override
  final String ext;
  @override
  final String mime;
  @override
  final String? path;
  @override
  final int width;
  @override
  final int height;
  @override
  final double size;
  @override
  final int sizeInBytes;
  @override
  final String url;

  factory _$MediaFormat([void Function(MediaFormatBuilder)? updates]) =>
      (new MediaFormatBuilder()..update(updates))._build();

  _$MediaFormat._(
      {required this.name,
      required this.hash,
      required this.ext,
      required this.mime,
      this.path,
      required this.width,
      required this.height,
      required this.size,
      required this.sizeInBytes,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'MediaFormat', 'name');
    BuiltValueNullFieldError.checkNotNull(hash, r'MediaFormat', 'hash');
    BuiltValueNullFieldError.checkNotNull(ext, r'MediaFormat', 'ext');
    BuiltValueNullFieldError.checkNotNull(mime, r'MediaFormat', 'mime');
    BuiltValueNullFieldError.checkNotNull(width, r'MediaFormat', 'width');
    BuiltValueNullFieldError.checkNotNull(height, r'MediaFormat', 'height');
    BuiltValueNullFieldError.checkNotNull(size, r'MediaFormat', 'size');
    BuiltValueNullFieldError.checkNotNull(
        sizeInBytes, r'MediaFormat', 'sizeInBytes');
    BuiltValueNullFieldError.checkNotNull(url, r'MediaFormat', 'url');
  }

  @override
  MediaFormat rebuild(void Function(MediaFormatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaFormatBuilder toBuilder() => new MediaFormatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaFormat &&
        name == other.name &&
        hash == other.hash &&
        ext == other.ext &&
        mime == other.mime &&
        path == other.path &&
        width == other.width &&
        height == other.height &&
        size == other.size &&
        sizeInBytes == other.sizeInBytes &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, hash.hashCode);
    _$hash = $jc(_$hash, ext.hashCode);
    _$hash = $jc(_$hash, mime.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, sizeInBytes.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaFormat')
          ..add('name', name)
          ..add('hash', hash)
          ..add('ext', ext)
          ..add('mime', mime)
          ..add('path', path)
          ..add('width', width)
          ..add('height', height)
          ..add('size', size)
          ..add('sizeInBytes', sizeInBytes)
          ..add('url', url))
        .toString();
  }
}

class MediaFormatBuilder implements Builder<MediaFormat, MediaFormatBuilder> {
  _$MediaFormat? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _hash;
  String? get hash => _$this._hash;
  set hash(String? hash) => _$this._hash = hash;

  String? _ext;
  String? get ext => _$this._ext;
  set ext(String? ext) => _$this._ext = ext;

  String? _mime;
  String? get mime => _$this._mime;
  set mime(String? mime) => _$this._mime = mime;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  double? _size;
  double? get size => _$this._size;
  set size(double? size) => _$this._size = size;

  int? _sizeInBytes;
  int? get sizeInBytes => _$this._sizeInBytes;
  set sizeInBytes(int? sizeInBytes) => _$this._sizeInBytes = sizeInBytes;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  MediaFormatBuilder();

  MediaFormatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _hash = $v.hash;
      _ext = $v.ext;
      _mime = $v.mime;
      _path = $v.path;
      _width = $v.width;
      _height = $v.height;
      _size = $v.size;
      _sizeInBytes = $v.sizeInBytes;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaFormat other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MediaFormat;
  }

  @override
  void update(void Function(MediaFormatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaFormat build() => _build();

  _$MediaFormat _build() {
    final _$result = _$v ??
        new _$MediaFormat._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'MediaFormat', 'name'),
          hash: BuiltValueNullFieldError.checkNotNull(
              hash, r'MediaFormat', 'hash'),
          ext:
              BuiltValueNullFieldError.checkNotNull(ext, r'MediaFormat', 'ext'),
          mime: BuiltValueNullFieldError.checkNotNull(
              mime, r'MediaFormat', 'mime'),
          path: path,
          width: BuiltValueNullFieldError.checkNotNull(
              width, r'MediaFormat', 'width'),
          height: BuiltValueNullFieldError.checkNotNull(
              height, r'MediaFormat', 'height'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'MediaFormat', 'size'),
          sizeInBytes: BuiltValueNullFieldError.checkNotNull(
              sizeInBytes, r'MediaFormat', 'sizeInBytes'),
          url:
              BuiltValueNullFieldError.checkNotNull(url, r'MediaFormat', 'url'),
        );
    replace(_$result);
    return _$result;
  }
}

class _$MetaData extends MetaData {
  @override
  final Pagination pagination;

  factory _$MetaData([void Function(MetaDataBuilder)? updates]) =>
      (new MetaDataBuilder()..update(updates))._build();

  _$MetaData._({required this.pagination}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        pagination, r'MetaData', 'pagination');
  }

  @override
  MetaData rebuild(void Function(MetaDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MetaDataBuilder toBuilder() => new MetaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MetaData && pagination == other.pagination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pagination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MetaData')
          ..add('pagination', pagination))
        .toString();
  }
}

class MetaDataBuilder implements Builder<MetaData, MetaDataBuilder> {
  _$MetaData? _$v;

  PaginationBuilder? _pagination;
  PaginationBuilder get pagination =>
      _$this._pagination ??= new PaginationBuilder();
  set pagination(PaginationBuilder? pagination) =>
      _$this._pagination = pagination;

  MetaDataBuilder();

  MetaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pagination = $v.pagination.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MetaData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MetaData;
  }

  @override
  void update(void Function(MetaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MetaData build() => _build();

  _$MetaData _build() {
    _$MetaData _$result;
    try {
      _$result = _$v ??
          new _$MetaData._(
            pagination: pagination.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pagination';
        pagination.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'MetaData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Pagination extends Pagination {
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int pageCount;
  @override
  final int total;

  factory _$Pagination([void Function(PaginationBuilder)? updates]) =>
      (new PaginationBuilder()..update(updates))._build();

  _$Pagination._(
      {required this.page,
      required this.pageSize,
      required this.pageCount,
      required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(page, r'Pagination', 'page');
    BuiltValueNullFieldError.checkNotNull(pageSize, r'Pagination', 'pageSize');
    BuiltValueNullFieldError.checkNotNull(
        pageCount, r'Pagination', 'pageCount');
    BuiltValueNullFieldError.checkNotNull(total, r'Pagination', 'total');
  }

  @override
  Pagination rebuild(void Function(PaginationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaginationBuilder toBuilder() => new PaginationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pagination &&
        page == other.page &&
        pageSize == other.pageSize &&
        pageCount == other.pageCount &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, pageCount.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Pagination')
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('pageCount', pageCount)
          ..add('total', total))
        .toString();
  }
}

class PaginationBuilder implements Builder<Pagination, PaginationBuilder> {
  _$Pagination? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  int? _pageCount;
  int? get pageCount => _$this._pageCount;
  set pageCount(int? pageCount) => _$this._pageCount = pageCount;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PaginationBuilder();

  PaginationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _pageSize = $v.pageSize;
      _pageCount = $v.pageCount;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Pagination other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Pagination;
  }

  @override
  void update(void Function(PaginationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Pagination build() => _build();

  _$Pagination _build() {
    final _$result = _$v ??
        new _$Pagination._(
          page: BuiltValueNullFieldError.checkNotNull(
              page, r'Pagination', 'page'),
          pageSize: BuiltValueNullFieldError.checkNotNull(
              pageSize, r'Pagination', 'pageSize'),
          pageCount: BuiltValueNullFieldError.checkNotNull(
              pageCount, r'Pagination', 'pageCount'),
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'Pagination', 'total'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
