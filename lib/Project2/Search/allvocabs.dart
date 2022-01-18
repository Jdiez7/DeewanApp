
import 'package:appwithfirebase/Project2/Search/vocab.dart';
import 'package:appwithfirebase/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HoldVocab with ChangeNotifier{
  final List<Vocab> allVocabs = [];
  final dataBaseService = DeewanDataBaseService();

  HoldVocab(){
    final dataBaseService = DeewanDataBaseService();
    dataBaseService.backendVocabs.listen((event) {
      print(event.toString());
      for (var element in event) {
        if(!allVocabs.contains(element)) {
          allVocabs.add(element);
          notifyListeners();
        }
      }
    });
  }
}


final allVocabs2 = <Vocab>[
  const Vocab(
    id: 1,
    arabicMain: 'مَرحَبا',
    englishMain: 'Hello',
    exampleSentence:
    'EXAMPLE SENTENCE Hello',
  ),
  const Vocab(
    id: 2,
    arabicMain: 'يُوم',
    englishMain: 'Day',
    exampleSentence:
      'Example sentence DAY'
  ),
  const Vocab(
    id: 3,
    arabicMain: 'مَدرَسِة',
    englishMain: 'School',
    exampleSentence: 'Example Sentence School'
  ),
  const Vocab(
    id: 4,
    arabicMain: 'بَيت',
    englishMain: 'House',
    exampleSentence: 'Example Sentence House'
  ),
  const Vocab(
    id: 5,
    arabicMain: 'كْتير',
    englishMain: 'very',
    exampleSentence: 'Example Sentence with very'),
  const Vocab(
    id: 6,
    arabicMain: 'كْبير',
    englishMain: 'big',
    exampleSentence: 'Example sentence with big'),
  const Vocab(
    id: 7,
    arabicMain: 'شَجَرة',
    englishMain: 'Tree',
    exampleSentence:
  'Example sentence with tree'
  ),
  const Vocab(
    id: 8,
    arabicMain: 'سِيّارة',
    englishMain: 'Car',
    exampleSentence: 'Example Sentence with Car'),
  const Vocab(
    id: 9,
    arabicMain: 'كْتاب',
    englishMain: 'Book',
    exampleSentence:
'Example sentence with Book'  ),
  const Vocab(
      id: 10,
      arabicMain: 'مَدينة',
      englishMain: 'City',
      exampleSentence:
'Example Sentence with City',),];