// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<dynamic> sendOtp(String number) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', number));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/check_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> verifyOtp(String number, String otp) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', number));
    _data.fields.add(MapEntry('otp', otp));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/verify_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> register(
    String emailOrPhone,
    String name,
    String email, {
    File? profileImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', emailOrPhone));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('email_id', email));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'profile_image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/register_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addBusiness(
    String? userId,
    String? name,
    String? address,
    String? mobileNumber,
    String? categoryId,
    String? aboutBusiness,
    String? latLong,
    String? whatsappNo,
    String? referralCode, {
    File? profileImage,
    List<MultipartFile>? attachment,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (name != null) {
      _data.fields.add(MapEntry('name', name));
    }
    if (address != null) {
      _data.fields.add(MapEntry('address', address));
    }
    if (mobileNumber != null) {
      _data.fields.add(MapEntry('mobile_number', mobileNumber));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (aboutBusiness != null) {
      _data.fields.add(MapEntry('about_business', aboutBusiness));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (whatsappNo != null) {
      _data.fields.add(MapEntry('whatsapp_number', whatsappNo));
    }
    if (referralCode != null) {
      _data.fields.add(MapEntry('referral_code', referralCode));
    }
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (attachment != null) {
      _data.files.addAll(attachment.map((i) => MapEntry('attachments[]', i)));
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/register_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> editBusiness(
    String? businessId,
    String? name,
    String? address,
    String? mobileNumber,
    String? categoryId,
    String? aboutBusiness,
    String? latLong,
    String? whatsappNo,
    List<String> oldAttachment, {
    File? profileImage,
    List<MultipartFile>? attachment,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (name != null) {
      _data.fields.add(MapEntry('name', name));
    }
    if (address != null) {
      _data.fields.add(MapEntry('address', address));
    }
    if (mobileNumber != null) {
      _data.fields.add(MapEntry('mobile_number', mobileNumber));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (aboutBusiness != null) {
      _data.fields.add(MapEntry('about_business', aboutBusiness));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (whatsappNo != null) {
      _data.fields.add(MapEntry('whatsapp_number', whatsappNo));
    }
    oldAttachment.forEach((i) {
      _data.fields.add(MapEntry('old_attachments[]', i));
    });
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (attachment != null) {
      _data.files.addAll(attachment.map((i) => MapEntry('attachments[]', i)));
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getCategories(String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_categories',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> explore(
    String? catId,
    String? latLong,
    String? userId,
    String pageNo,
    String location,
    String offerAvailable,
    List<String> rating,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (catId != null) {
      _data.fields.add(MapEntry('category_id', catId));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    _data.fields.add(MapEntry('location', location));
    _data.fields.add(MapEntry('offer_available', offerAvailable));
    rating.forEach((i) {
      _data.fields.add(MapEntry('rating[]', i));
    });
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/explore',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> businessDetails(
    String? catId,
    String? latLong,
    String? userId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (catId != null) {
      _data.fields.add(MapEntry('business_id', catId));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/business_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> myBusinessDetails(
    String? catId,
    String? latLong,
    String? userId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (catId != null) {
      _data.fields.add(MapEntry('business_id', catId));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_business_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> myBusiness(String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_businesses',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addPost(
    String userId,
    String businessId,
    String details, {
    File? profileImage,
    File? videoFile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('business_id', businessId));
    _data.fields.add(MapEntry('details', details));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (videoFile != null) {
      if (videoFile != null) {
        _data.files.add(
          MapEntry(
            'video',
            MultipartFile.fromFileSync(
              videoFile.path,
              filename: videoFile.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_business_post',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> editPost(
    String postId,
    String details, {
    File? profileImage,
    File? videoFile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('post_id', postId));
    _data.fields.add(MapEntry('details', details));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (videoFile != null) {
      if (videoFile != null) {
        _data.files.add(
          MapEntry(
            'video',
            MultipartFile.fromFileSync(
              videoFile.path,
              filename: videoFile.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_business_post',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addOffer(
    String userId,
    String businessId,
    String name,
    String details,
    String startDate,
    String endDate,
    List<String> highlightPoints, {
    File? profileImage,
    File? videoFile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('business_id', businessId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('details', details));
    _data.fields.add(MapEntry('start_date', startDate));
    _data.fields.add(MapEntry('end_date', endDate));
    highlightPoints.forEach((i) {
      _data.fields.add(MapEntry('highlight_points[]', i));
    });
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (videoFile != null) {
      if (videoFile != null) {
        _data.files.add(
          MapEntry(
            'video',
            MultipartFile.fromFileSync(
              videoFile.path,
              filename: videoFile.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_business_offer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> editOffer(
    String offerId,
    String name,
    String details,
    String startDate,
    String endDate,
    List<String> highlightPoints, {
    File? profileImage,
    File? videoFile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('offer_id', offerId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('details', details));
    _data.fields.add(MapEntry('start_date', startDate));
    _data.fields.add(MapEntry('end_date', endDate));
    highlightPoints.forEach((i) {
      _data.fields.add(MapEntry('highlight_points[]', i));
    });
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (videoFile != null) {
      if (videoFile != null) {
        _data.files.add(
          MapEntry(
            'video',
            MultipartFile.fromFileSync(
              videoFile.path,
              filename: videoFile.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_business_offer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> postDetails(String? postId, String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (postId != null) {
      _data.fields.add(MapEntry('post_id', postId));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_post_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> offerDetails(String? offerId, String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (offerId != null) {
      _data.fields.add(MapEntry('offer_id', offerId));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_offer_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getFeeds(
    String? latLong,
    String? userId,
    String? categoryId,
    String? dateRange,
    String? location,
    String pageNo,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (dateRange != null) {
      _data.fields.add(MapEntry('date_range', dateRange));
    }
    if (location != null) {
      _data.fields.add(MapEntry('location', location));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_feeds',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getHome(String? latLong, String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/home',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getSpecialOffer(
    String? userId,
    String? categoryId,
    String? dateRange,
    String latLng,
    String? location,
    String pageNo,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (dateRange != null) {
      _data.fields.add(MapEntry('date_range', dateRange));
    }
    _data.fields.add(MapEntry('lat_long', latLng));
    if (location != null) {
      _data.fields.add(MapEntry('location', location));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_special_offers',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> businessReqList(
    String? userId,
    String? categoryId,
    String? sortOrder,
    String? lookingId,
    String? investmentCapId,
    String latLng,
    String pageNo,
    String location,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (sortOrder != null) {
      _data.fields.add(MapEntry('sort_order', sortOrder));
    }
    if (lookingId != null) {
      _data.fields.add(MapEntry('looking_for_id', lookingId));
    }
    if (investmentCapId != null) {
      _data.fields.add(MapEntry('investement_cap_id', investmentCapId));
    }
    _data.fields.add(MapEntry('lat_long', latLng));
    _data.fields.add(MapEntry('page_number', pageNo));
    _data.fields.add(MapEntry('location', location));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/business_requirement_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getWulf() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_wulf_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getCapacity(String? wulfId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (wulfId != null) {
      _data.fields.add(MapEntry('wulf_id', wulfId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_investment_capacity_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> deleteBusinessReq(String? requirementId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (requirementId != null) {
      _data.fields.add(MapEntry('requirement_id', requirementId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/delete_business_requirement',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> deleteBusiness(String? businessId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/delete_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> revokeBusinessReq(String? requirementId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (requirementId != null) {
      _data.fields.add(MapEntry('requirement_id', requirementId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/revoke_business_requirement',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addBusinessReq(
    String userId,
    String name,
    String location,
    String latLng,
    String wulfId,
    String capacityId,
    String history,
    String note,
    String canInvest,
    List<String> catIds,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('location', location));
    _data.fields.add(MapEntry('lat_long', latLng));
    _data.fields.add(MapEntry('wulf_id', wulfId));
    _data.fields.add(MapEntry('investment_cap_id', capacityId));
    _data.fields.add(MapEntry('history', history));
    _data.fields.add(MapEntry('note', note));
    _data.fields.add(MapEntry('can_invest', canInvest));
    catIds.forEach((i) {
      _data.fields.add(MapEntry('category_ids[]', i));
    });
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_business_requirement',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> editBusinessReq(
    String reqId,
    String name,
    String location,
    String latLng,
    String wulfId,
    String capacityId,
    String history,
    String note,
    String canInvest,
    List<String> catIds,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('requirement_id', reqId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('location', location));
    _data.fields.add(MapEntry('lat_long', latLng));
    _data.fields.add(MapEntry('wulf_id', wulfId));
    _data.fields.add(MapEntry('investment_cap_id', capacityId));
    _data.fields.add(MapEntry('history', history));
    _data.fields.add(MapEntry('note', note));
    _data.fields.add(MapEntry('can_invest', canInvest));
    catIds.forEach((i) {
      _data.fields.add(MapEntry('category_ids[]', i));
    });
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_business_requirement',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getMyProfile(String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_profile_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getFollowList(String? userId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_business_following_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getFollowersList(String? businessId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_business_followers',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getUserProfile(String? userId, String? loginUserId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (loginUserId != null) {
      _data.fields.add(MapEntry('login_user_id', loginUserId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/user_profile_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> updateProfile(
    String userId,
    String name,
    String experience,
    String education,
    String specializationId,
    String about, {
    File? profileImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('experience', experience));
    _data.fields.add(MapEntry('education', education));
    _data.fields.add(MapEntry('specialization_id', specializationId));
    _data.fields.add(MapEntry('about', about));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'profile_image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_profile',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> sendBusinessRequest(
    String? userId,
    String? businessId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_requirement_id', businessId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/send_business_requirement_request',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getBusinessRequested(String? userId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_requested_business_requirements',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getBusinessReceivedRequest(
    String? userId,
    String pageNo,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/my_received_business_requirement_requests',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> acceptBusinessRequest(String? userId, String? reqId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (reqId != null) {
      _data.fields.add(MapEntry('request_id', reqId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/accept_business_requirement_request',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> followBusiness(String? userId, String? businessId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/follow_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> unfollowBusiness(String? userId, String? followId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (followId != null) {
      _data.fields.add(MapEntry('follow_id', followId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/unfollow_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> likeBusiness(
    String? userId,
    String? businessId,
    String? postId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (postId != null) {
      _data.fields.add(MapEntry('business_post_id', postId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/like_business_post',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> unlikeBusiness(String? userId, String? likeId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (likeId != null) {
      _data.fields.add(MapEntry('liked_id', likeId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/unlike_business_post',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> likeOffer(
    String? userId,
    String? businessId,
    String? offerId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (offerId != null) {
      _data.fields.add(MapEntry('business_offer_id', offerId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/like_business_offer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> unlikeOffer(String? userId, String? likeId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (likeId != null) {
      _data.fields.add(MapEntry('offer_liked_id', likeId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/unlike_business_offer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addReview(
    String? userId,
    String? businessId,
    String? review,
    String? rating,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (review != null) {
      _data.fields.add(MapEntry('review', review));
    }
    if (rating != null) {
      _data.fields.add(MapEntry('rating', rating));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_review_rating',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addPostComment(
    String? userId,
    String? businessId,
    String? postId,
    String? comment,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (postId != null) {
      _data.fields.add(MapEntry('business_post_id', postId));
    }
    if (comment != null) {
      _data.fields.add(MapEntry('comment', comment));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_business_post_comment',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addOfferComment(
    String? userId,
    String? businessId,
    String? offerId,
    String? comment,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (businessId != null) {
      _data.fields.add(MapEntry('business_id', businessId));
    }
    if (offerId != null) {
      _data.fields.add(MapEntry('business_offer_id', offerId));
    }
    if (comment != null) {
      _data.fields.add(MapEntry('comment', comment));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/add_business_offer_comment',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getChatList(String? userId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_chat_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getSingleChat(
    String? userId,
    String? chatId,
    String pageNo,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (chatId != null) {
      _data.fields.add(MapEntry('chat_id', chatId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_messages',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> sendMsg(
    String? userId,
    String? chatId,
    String? message,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (chatId != null) {
      _data.fields.add(MapEntry('chat_id', chatId));
    }
    if (message != null) {
      _data.fields.add(MapEntry('message', message));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/send_message',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> initiateChat(
    String? userId,
    String? chatId,
    String? otherUserId,
    String? type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (chatId != null) {
      _data.fields.add(MapEntry('business_requirement_id', chatId));
    }
    if (otherUserId != null) {
      _data.fields.add(MapEntry('other_user_id', otherUserId));
    }
    if (type != null) {
      _data.fields.add(MapEntry('type', type));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/initiate_chat',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> globalSearch(String? keyword, String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (keyword != null) {
      _data.fields.add(MapEntry('keyword', keyword));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/global_search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> legalPageList() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_page_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> legalPageDetails(String? slug) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (slug != null) {
      _data.fields.add(MapEntry('slug', slug));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_page_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> deleteAccount(String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/delete_account',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> updateFirebaseToken(String userId, String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('firebase_token', token));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/update_firebase_token',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getNotification(String userId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_notifications',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> readNotification(String userId, String notificationId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('notification_id', notificationId));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/read_notification',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> acceptDisclaimer(String? data, String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (data != null) {
      _data.fields.add(MapEntry('data_accepted', data));
    }
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/save_user_disclaimer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> helpAndSupport() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/help_and_support',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> blockUser(String? userId, String? blockUserId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (blockUserId != null) {
      _data.fields.add(MapEntry('block_user_id', blockUserId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/block_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getTutorials(String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/get_tutorials',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> blockUserList(String? userId, String pageNo) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('page_number', pageNo));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/blocked_users_list',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> sendChatRequest(String? userId, String otherUserid) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    _data.fields.add(MapEntry('other_user_id', otherUserid));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'https://beta.bizyaari.com/api/user/v1/send_user_chat_request',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
