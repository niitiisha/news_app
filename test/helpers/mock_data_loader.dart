// Reads a mock JSON file from test/mock_data/ and returns it as a String
import 'dart:io';

String loadMockJson(String fileName) {
  return File('test/mock_data/$fileName').readAsStringSync();
}
