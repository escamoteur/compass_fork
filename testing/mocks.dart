// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

class MockHttpClient extends Mock implements Client {}

class MockHttpClientResponse extends Mock implements Response {}

extension HttpMethodMocks on MockHttpClient {
  void mockGet(Uri path, Object object) {
    when(() => get(path, headers: any(named: 'headers')))
        .thenAnswer((invocation) {
      final response = MockHttpClientResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.bodyBytes)
          .thenReturn(utf8.encode(jsonEncode(object)));
      return Future.value(response);
    });
  }

  void mockPost(Uri path, Object object, [int statusCode = 201]) {
    when(() => post(path,
        body: any(named: 'body'),
        encoding: any(
          named: 'encoding',
        ),
        headers: any(named: 'headers'))).thenAnswer((invocation) {
      final response = MockHttpClientResponse();
      when(() => response.statusCode).thenReturn(statusCode);
      when(() => response.bodyBytes)
          .thenReturn(utf8.encode(jsonEncode(object)));
      return Future.value(response);
    });
  }

  void mockDelete(Uri path) {
    when(() => delete(path)).thenAnswer((invocation) {
      final response = MockHttpClientResponse();
      when(() => response.statusCode).thenReturn(204);
      return Future.value(response);
    });
  }
}
