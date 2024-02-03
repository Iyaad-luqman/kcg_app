// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kcg_app/dashboard.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:kcg_app/marks_display.dart';
import 'package:kcg_app/profile.dart';
import 'package:kcg_app/timetable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Marks extends StatefulWidget {
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  int _selectedIndex = -1;
  Future<List<List<dynamic>>>? _marksFuture;

  Future<String> _getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.getString('sessionId') ?? '';
    return sessionId;
  }

  Future<String> _getRedirectUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String redirectUrl = prefs.getString('redirectUrl') ?? '';
    return redirectUrl;
  }

  void printLongString(String str) {
    if (str.length <= 1000) {
      print(str);
    } else {
      print(str.substring(0, 1000));
      printLongString(str.substring(1000));
    }
  }
String ? name;
void _loadNameAndSemester() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
    });
  }



@override
void initState() {
  super.initState();
  // clearSharedPreferences().then((value) => print('Cleared shared preferences'));
  _marksFuture = _fetchData();
    _loadNameAndSemester();

}


Future<void> clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
Future<List<List<dynamic>>> _fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonData = prefs.getString('data');
  if (jsonData == null || jsonData.isEmpty || jsonData == '' || jsonData == '[]') {
    String sessionId = await _getSessionId();
    String redirectUrl = await _getRedirectUrl();
    return await fetchMarks(redirectUrl, sessionId);
  } else {
    return (jsonDecode(jsonData) as List).cast<List<dynamic>>();
  }
}



  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Profile Page'),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Timetable()));
      }
      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }

  Future<List<List<dynamic>>> fetchMarks(String redirectUrl, String sessionId) async {
    final url = 'http://studentlogin.kcgcollege.ac.in$redirectUrl';
    debugPrint('url: $url');
    final headers = {
      'Host': 'studentlogin.kcgcollege.ac.in',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'ASP.NET_SessionId=$sessionId',
    };
    // const body = '__EVENTTARGET=&__EVENTARGUMENT';
        const body = '__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwUJODQwNDExMTAzD2QWAgIBD2QWHgIDDw8WAh4EVGV4dAUZS0NHIENvbGxlZ2Ugb2YgVGVjaG5vbG9neWRkAgcPDxYCHgdWaXNpYmxlaGRkAgkPDxYCHwFoZGQCDw8PFgIfAWhkZAIRDw8WAh8ABQ5JeWFhZCBMdXFtYW4gS2RkAhMPDxYCHwAFCjkxMjMxMDQwNzBkZAIVDw8WAh8ABSFGSVJTVCBZRUFSLVNjaWVuY2UgQW5kIEh1bWFuaXRpZXNkZAIXDw8WAh8ABQExZGQCGQ8PFgIfAAUEMjAyM2RkAiEPDxYCHwAFCjkxMjMxMDQwNzBkZAIpDxYEHgdkaXNwbGF5BQRub25lHwFoZAIrD2QWMAIBDw8WAh8BZ2RkAgMPDxYCHwFnZBYCAgkPBTJmcHNwcmVhZHN0YXRlOjJkOTZlMDJhLTg0NjktNGYwOS1hODdmLTY2ZTE3YjlkNDI0MmQCBQ8PFgIfAWdkZAIHDw8WAh8BZ2QWCgIBDw8WAh8BZ2RkAgMPDxYCHwFnZGQCBQ8PFgIfAWdkZAIHDw8WAh8BZ2RkAgkPBTJmcHNwcmVhZHN0YXRlOmY3YTUwZjBjLTk0NjQtNDkwZS1iMjc4LWYzYTVhZDZhYjliN2QCCw8PFgIfAWdkZAINDw8WAh8BZ2QWKgIFDw8WAh8BaGRkAgcPDxYCHwFoZGQCCQ8PFgIfAWhkZAILDw8WAh8BaGRkAg0PDxYCHwFoZGQCDw8PFgIfAWhkZAITD2QWBAIDD2QWAmYPZBYCAgMPZBYCAgMPEGRkFgBkAgUPEGQQFQMDQWxsA0NBTQpVbml2ZXJzaXR5FQMDQWxsA0NBTQpVbml2ZXJzaXR5FCsDA2dnZxYBZmQCFQ9kFgICAQ8FMmZwc3ByZWFkc3RhdGU6NTIzZmM1YTEtZmYzZi00MTQ0LWIzYmEtNWE5YzFjZTgxODg2ZAIXDw8WAh8BaGRkAhkPDxYCHwFoZGQCHQ8PFgIfAWhkZAIjD2QWAgIBD2QWAmYPZBYCAgEPZBYYAgUPZBYCAgMPPCsACQEADxYCHg1OZXZlckV4cGFuZGVkZxYCHgdvbmNsaWNrBR1PbkNoZWNrQm94Q2hlY2tDaGFuZ2VkKGV2ZW50KWQCBw9kFgICAw8QZGQWAGQCCQ8QZGQWAGQCCw8QZGQWAGQCGw8QZGQWAWZkAh0PBTJmcHNwcmVhZHN0YXRlOjM0N2JhM2Q3LTE4YzEtNDBmZi05MjRmLTJiNGZlMGRmYTk1M2QCIw8QZGQWAWZkAicPEGRkFgFmZAIrDxBkZBYBZmQCMQ8QZGQWAWZkAjUPEGRkFgFmZAI7DxBkZBYBZmQCJQ8PFgIfAWhkZAIpDw8WAh8BaGRkAisPDxYCHwFoZGQCLQ9kFgJmD2QWBAIBDw8WAh8BaGRkAgMPDxYCHwFoZBYCAgMPEGRkFgBkAi8PDxYCHwFoZGQCMQ8QDxYCHwFoZGQWAGQCMw8FMmZwc3ByZWFkc3RhdGU6NGNlMDBiMzctZjc0Yi00ODY5LWE4NDYtY2RmN2U0ZDJmM2I1ZAI1DwUyZnBzcHJlYWRzdGF0ZTpiMzFmN2U3ZC1hYWE1LTQwZjAtYjhhNy1jMjliOGUxMTdmMGNkAjcPPCsACQEADxYCHwNnZGQCEQ8PFgIfAWdkZAITDw8WAh8BZ2QWCAIPDw8WAh8BZ2RkAhEPDxYCHwFnZGQCEw8PFgIfAWdkZAIVDwUyZnBzcHJlYWRzdGF0ZTowMGRlZmM3My0xZDc2LTRkYzktYjgzZi1jZWE0MGI5ODdiOGRkAhcPDxYCHwFnZGQCGQ8PFgIfAWdkFhQCAQ8PFgIfAWdkZAIDDw8WAh8BZ2RkAgUPDxYCHwFnZGQCBw8PFgIfAWdkZAIJDw8WAh8BZ2RkAgsPDxYCHwFnZGQCDQ8PFgIfAWdkZAIPD2QWBAIDD2QWAmYPZBYCAgEPEGRkFgBkAgcPPCsAEQIBEBYAFgAWAAwUKwAAZAIRDwUyZnBzcHJlYWRzdGF0ZTo5ZjNkYzc1ZS02NWIyLTQ1YjktYTlkYy00OTk2YTQ0ZTRlYjlkAhMPBTJmcHNwcmVhZHN0YXRlOjMxMjYwZDc3LTBiNTUtNGI3OS1iNjlkLWZjOTQ5Y2JmMzEyNWQCHQ8PFgIfAWdkZAIfDw8WAh8BZ2QWEgIBDw8WAh8BZ2RkAgMPDxYCHwFnZGQCBQ8PFgIfAWdkZAIHDw8WAh8BZ2RkAgkPDxYCHwFnZGQCCw8PFgIfAWdkZAIRDwUyZnBzcHJlYWRzdGF0ZTo1YjI2YmM2OC02NDMxLTRmYjMtYTcwNC04NzlhN2EzY2MxNGZkAhMPZBYCAgEPZBYEZg9kFgICAQ8QDxYGHg1EYXRhVGV4dEZpZWxkBQhsaWJfbmFtZR4ORGF0YVZhbHVlRmllbGQFCGxpYl9jb2RlHgtfIURhdGFCb3VuZGdkEBUCJUxpYnJhcnkgQW5kIEtub3dsZWRnZSBSZXNvdXJjZSBDZW50cmUJQm9vayBCYW5rFQIBMQEyFCsDAmdnFgFmZAIBD2QWAgIBDw8WAh8ABQowMy8wMi8yMDI0ZGQCFQ9kFgICAQ9kFgZmD2QWAgIBDxAPFgYfBQUIbGliX25hbWUfBgUIbGliX2NvZGUfB2dkEBUCJUxpYnJhcnkgQW5kIEtub3dsZWRnZSBSZXNvdXJjZSBDZW50cmUJQm9vayBCYW5rFQIBMQEyFCsDAmdnFgFmZAICD2QWAgIBDxAPFgYfBQUKZGVwYXJ0bWVudB8GBQpkZXBhcnRtZW50HwdnZBAVPAttZWNoYW5pY2FsIBBNLkUuIFZMU0kgREVTSUdOJkVMRUNUUklDQUwgQU5EIEVMRUNUUk9OSUNTIEVOR0lORUVSSU5HFnNjaWVuY2UgYW5kIGh1bWFuaXRpZXMnRWxlY3Ryb25pY3MgSW5zdHJ1bWVudGF0aW9uIEVuZ2luZWVyaW5nB0VOR0xJU0gJQ0hFTUlTVFJZHU0uRS5NQU5VRkFDVFVSSU5HIEVOR0lORUVSSU5HEUNJVklMIEVOR0lORUVSSU5HHU1BU1RFUiBPRiBCVVNJTkVTUyBNQU5BR0VNRU5UKUVMRUNUUk9OSUNTIENPTU1VTklDQVRJT04gQU5EIEVOR0lORUVSSU5HIENvbXB1dGVyIFNpY2VuY2UgYW5kIEVuZ2luZWVyaW5nAWUlRWxlY3Ryb25pY3MgQ29tbXVuaWNhdGlvbiBFbmdpbmVlcmluZwxBZXJvbmF1dGljYWwpRUxFQ1RST05JQ1MgQU5EIENPTU1VTklDQVRJT04gRU5HSU5FRVJJTkcQQ29tcHV0ZXIgc2NpZW5jZRdNZWNoYXRyb25pY3MgRW5naWVlcmluZyFNLkUuUE9XRVIgIEVMRUNUUk9OSUNTIEFORCBEUklWRVMgTS5FIFBPV0VSIEVMRUNUUk9OSUNTIEFORCBEUklWRVMSUEhZU0lDQUwgRURVQ0FUSU9OB1BIWVNJQ1MFQUkmRFMWRUxFQ1RSSUNBTCBFTkdJTkVFUklORwNIR0krRUxFQ1RST05JQ1MgQU5EIElOU1RSVU1FTlRBVElPTiBFTkdJTkVFUklORxZNLkUuRU5HSU5FRVJJTkcgREVTSUdOH01BU1RFUiBPRiBDT01QVVRFUiAgQVBQTElDQVRJT04ZTUFOVUZBQ1RVUklORyBFTkdJTkVFUklORwVNYXRocxxQb3dlciBFbGVjdHJvbmljIGFuZCAgRHJpdmVzB0dFTkVSQUwXQXV0byBNb2JpbGUgRW5naW5lZXJpbmcWTUVDSEFOSUNBTCBFTkdJTkVFUklORxZBVVRPTU9CSUxFIEVOR0lORUVSSU5HGEFFUk9OQVVUSUNBTCBFTkdJTkVFUklORxhNRUNIQVRST05JQ1MgRU5HSU5FRVJJTkcVQUVST1NQQUNFIEVOR0lORUVSSU5HJUVsZWN0cmljYWwgJiBlbGVjdHJvbmljcyAgRW5naW5lZXJpbmcTR0VORVJBTCBFTkdJTkVFUklORwABLQpBdXRvbW9iaWxlEkZBU0hJT04gVEVDSE5PTE9HWRlNLkUuIENPTU1VTklDQVRJT04gU1lTVEVNJ2VsZWN0cm9uaWNzICYgY29tbXVuaWNhdGlvbiBlbmdpbmVlcmluZwNOSUwjTElCUkFSWSAmIEtOT1dMRURHRSBSRVNPVVJDRSBDRU5UUkULTUFUSEVNQVRJQ1MJYWVyb3NwYWNlIE0uRS5DT01QVVRFUiBTQ0lFTkNFIEVOR0lORUVSSU5HDG1lY2hhdHJvbmljcxRTQ0lFTkNFICYgSFVNQU5JVElFUyRFbGVjdHJvbmljIGNvbW11bmljYXRpb24gZW5naW5lZXJpbmcWSU5GT1JNQVRJT04gVEVDSE5PTE9HWQVjaXZpbBxDT01QVVRFUiBTQ0lFTkNFIEVOR0lORUVSSU5HB0FJICYgRFMgQ09NUFVURVIgU0NJRU5DRSBBTkQgRU5HSU5FRVJJTkcJRUNPTk9NSUNTFTwLbWVjaGFuaWNhbCAQTS5FLiBWTFNJIERFU0lHTiZFTEVDVFJJQ0FMIEFORCBFTEVDVFJPTklDUyBFTkdJTkVFUklORxZzY2llbmNlIGFuZCBodW1hbml0aWVzJ0VsZWN0cm9uaWNzIEluc3RydW1lbnRhdGlvbiBFbmdpbmVlcmluZwdFTkdMSVNICUNIRU1JU1RSWR1NLkUuTUFOVUZBQ1RVUklORyBFTkdJTkVFUklORxFDSVZJTCBFTkdJTkVFUklORx1NQVNURVIgT0YgQlVTSU5FU1MgTUFOQUdFTUVOVClFTEVDVFJPTklDUyBDT01NVU5JQ0FUSU9OIEFORCBFTkdJTkVFUklORyBDb21wdXRlciBTaWNlbmNlIGFuZCBFbmdpbmVlcmluZwFlJUVsZWN0cm9uaWNzIENvbW11bmljYXRpb24gRW5naW5lZXJpbmcMQWVyb25hdXRpY2FsKUVMRUNUUk9OSUNTIEFORCBDT01NVU5JQ0FUSU9OIEVOR0lORUVSSU5HEENvbXB1dGVyIHNjaWVuY2UXTWVjaGF0cm9uaWNzIEVuZ2llZXJpbmchTS5FLlBPV0VSICBFTEVDVFJPTklDUyBBTkQgRFJJVkVTIE0uRSBQT1dFUiBFTEVDVFJPTklDUyBBTkQgRFJJVkVTElBIWVNJQ0FMIEVEVUNBVElPTgdQSFlTSUNTBUFJJkRTFkVMRUNUUklDQUwgRU5HSU5FRVJJTkcDSEdJK0VMRUNUUk9OSUNTIEFORCBJTlNUUlVNRU5UQVRJT04gRU5HSU5FRVJJTkcWTS5FLkVOR0lORUVSSU5HIERFU0lHTh9NQVNURVIgT0YgQ09NUFVURVIgIEFQUExJQ0FUSU9OGU1BTlVGQUNUVVJJTkcgRU5HSU5FRVJJTkcFTWF0aHMcUG93ZXIgRWxlY3Ryb25pYyBhbmQgIERyaXZlcwdHRU5FUkFMF0F1dG8gTW9iaWxlIEVuZ2luZWVyaW5nFk1FQ0hBTklDQUwgRU5HSU5FRVJJTkcWQVVUT01PQklMRSBFTkdJTkVFUklORxhBRVJPTkFVVElDQUwgRU5HSU5FRVJJTkcYTUVDSEFUUk9OSUNTIEVOR0lORUVSSU5HFUFFUk9TUEFDRSBFTkdJTkVFUklORyVFbGVjdHJpY2FsICYgZWxlY3Ryb25pY3MgIEVuZ2luZWVyaW5nE0dFTkVSQUwgRU5HSU5FRVJJTkcAAS0KQXV0b21vYmlsZRJGQVNISU9OIFRFQ0hOT0xPR1kZTS5FLiBDT01NVU5JQ0FUSU9OIFNZU1RFTSdlbGVjdHJvbmljcyAmIGNvbW11bmljYXRpb24gZW5naW5lZXJpbmcDTklMI0xJQlJBUlkgJiBLTk9XTEVER0UgUkVTT1VSQ0UgQ0VOVFJFC01BVEhFTUFUSUNTCWFlcm9zcGFjZSBNLkUuQ09NUFVURVIgU0NJRU5DRSBFTkdJTkVFUklORwxtZWNoYXRyb25pY3MUU0NJRU5DRSAmIEhVTUFOSVRJRVMkRWxlY3Ryb25pYyBjb21tdW5pY2F0aW9uIGVuZ2luZWVyaW5nFklORk9STUFUSU9OIFRFQ0hOT0xPR1kFY2l2aWwcQ09NUFVURVIgU0NJRU5DRSBFTkdJTkVFUklORwdBSSAmIERTIENPTVBVVEVSIFNDSUVOQ0UgQU5EIEVOR0lORUVSSU5HCUVDT05PTUlDUxQrAzxnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2cWAWZkAgMPZBYCAgEPDxYCHwAFCjAzLzAyLzIwMjRkZAIjDw8WAh8BZ2RkAiUPDxYCHwFnZBYgAgEPDxYCHwFnZGQCAw8PFgIfAWdkZAIFDw8WAh8BZ2RkAgcPDxYCHwFnZGQCCw8PFgIfAWdkZAIPDw8WAh8BZ2RkAhEPDxYCHgdFbmFibGVkaGRkAhUPZBYCAgEPZBYCZg9kFggCCw8FMmZwc3ByZWFkc3RhdGU6Y2QyNmMyMWMtNWI2ZS00YWYxLWE0ZGMtOGQ2YWQ4MjMyNzdkZAIPDwUyZnBzcHJlYWRzdGF0ZTpiOWUzMWFhMS1hOTg1LTRlM2MtYWNmOS03ODI3NDRlZWViMWZkAhEPZBYCAgMPPCsAEQIBEBYAFgAWAAwUKwAAZAIVD2QWAgIND2QWAgIBD2QWAmYPZBYCAgEPZBYYAgUPZBYCAgMPPCsACQEADxYCHwNnFgIfBAUdT25DaGVja0JveENoZWNrQ2hhbmdlZChldmVudClkAgcPZBYCAgMPEGRkFgBkAgkPEGRkFgBkAgsPEGRkFgBkAhsPEGRkFgFmZAIdDwUyZnBzcHJlYWRzdGF0ZTpkYTg3NzNhYy1hNzYyLTRiMmItODQxZS03NmYyNDFlOTFhMjhkAiMPEGRkFgFmZAInDxBkZBYBZmQCKw8QZGQWAWZkAjEPEGRkFgFmZAI1DxBkZBYBZmQCOw8QZGQWAWZkAhsPZBYCZg9kFgQCAQ9kFgICAQ8QZGQWAGQCAw9kFgICAQ8QZGQWAGQCHQ9kFgICAg9kFgICAg9kFgICAQ8QZGQWAGQCJQ88KwARAgEQFgAWABYADBQrAABkAicPDxYCHwFoZGQCKQ8FMmZwc3ByZWFkc3RhdGU6MzU5MDk4NDYtYTg0Zi00OTM4LWI3MjktZjRmYjM0MDA5N2RhZAItDwUyZnBzcHJlYWRzdGF0ZTphYjI2N2VkOC1iOGYwLTQ0OTktOTUzZi1hZGM5NTk1ZTMyNmZkAi8PBTJmcHNwcmVhZHN0YXRlOjAxOWZkODdlLTg0YmMtNGIwMC05YTRiLTQwNjkyNWMwNjM3MmQCNQ9kFgYCAw8PFgIfAAUKMDMvMDIvMjAyNGRkAhEPDxYCHwAFCjAzLzAyLzIwMjRkZAIfD2QWAgIBDzwrABECARAWABYAFgAMFCsAAGQCKw9kFgQCAw9kFgICBw9kFgJmD2QWAgIBD2QWAgIBDxBkZBYBZmQCBw9kFgJmD2QWAgIBD2QWBAIBD2QWAmYPZBYCAgEPBTJmcHNwcmVhZHN0YXRlOjVlZmJlMTQyLTI1OGMtNGQ1Zi1iZTY4LTFlMTI2OTdiN2FmMmQCBQ8WAh8BaBYCAg0PBTJmcHNwcmVhZHN0YXRlOjU1MGU1OGIwLTU3ZDItNDllZi1hZTBlLWE4NDc2NDY2NTQwZmQCMQ9kFgICAQ8FMmZwc3ByZWFkc3RhdGU6OTY2ZmFjY2ItMWYwOC00YmQ3LTkyZTYtZjViNzIyNmY2NmU0ZAI3D2QWCgIBDxAPFgYfBQUHc3VibmFtZR8GBQpzdWJqZWN0X25vHwdnZBAVCgZTZWxlY3QXRXNzZW50aWFsIENvbW11bmljYXRpb24VTUFUUklDRVMgQU5EIENBTENVTFVTNEVuZ2luZWVyaW5nIFBoeXNpY3MgLyBFbmdpbmVlcmluZyBQaHlzaWNzIExhYm9yYXRvcnk2RW5naW5lZXJpbmcgQ2hlbWlzdHJ5L0VuZ2luZWVyaW5nIENoZW1pc3RyeSBMYWJvcmF0b3J5EFBST0dSQU1NSU5HIElOIEMWQ29tcHV0YXRpb25hbCBUaGlua2luZxJIZXJpdGFnZSBvZiBUYW1pbHMYQ09NTVVOSUNBVElPTiBMQUJPUkFUT1JZGEMgUFJPR1JBTU1JTkcgTEFCT1JBVE9SWRUKBlNlbGVjdAUyMTMyNwUyMTMyOAUyMTMyOQUyMTMzMAUyMTMzMQUyMTMzMwUyMTMzNQUyMTMzNgUyMTMzNxQrAwpnZ2dnZ2dnZ2dnFgFmZAIFDxBkZBYAZAILD2QWAgIBDzwrAAkBAA8WAh8DZ2RkAg0PBTJmcHNwcmVhZHN0YXRlOjc3MTIxN2Y0LTFhNDktNDFjZi05MmRhLTRjODNiODg1YWY2OWQCDw8FMmZwc3ByZWFkc3RhdGU6NTM0ODQ0MjktMGM2Ny00ZWExLWFhNjAtOGJiY2U4MWQ2ZmQxZAI7DxYCHwFoZAI9Dw8WAh8BZ2RkAj8PDxYCHwFnZBYIAgEPZBYGAgEPDxYCHwFnZGQCAw8PFgIfAWdkZAIFDw8WAh8BZ2RkAgUPZBYCAgEPZBYCZg9kFhACBQ8QZGQWAGQCDw8QZGQWAGQCEQ8QZGQWAGQCEw8QZGQWAWZkAhsPEGRkFgBkAh0PEGRkFgBkAh8PEGRkFgFmZAIhDxBkDxYBZhYBEAUEU2VsZgUBMWcWAWZkAgcPZBYCAgEPPCsAEQIBEBYAFgAWAAwUKwAAZAIJD2QWBAIND2QWAgIHDxBkZBYEZgIBAgICA2QCEw8FMmZwc3ByZWFkc3RhdGU6MTYxMTU0MTUtYjc2Ny00ZmJiLWIwODItNmFmMTBlZjNkNzA3ZAJDDw8WAh8BZ2RkAkUPDxYCHwFnZBYCAgEPZBYCAgEPPCsAEQMADxYCHwFoZAEQFgAWABYADBQrAABkAksPZBYEAgEPZBYCAgEPEA8WBh8FBQdzdWJuYW1lHwYFCnN1YmplY3Rfbm8fB2dkEBUKBlNlbGVjdBdFc3NlbnRpYWwgQ29tbXVuaWNhdGlvbhVNQVRSSUNFUyBBTkQgQ0FMQ1VMVVM0RW5naW5lZXJpbmcgUGh5c2ljcyAvIEVuZ2luZWVyaW5nIFBoeXNpY3MgTGFib3JhdG9yeTZFbmdpbmVlcmluZyBDaGVtaXN0cnkvRW5naW5lZXJpbmcgQ2hlbWlzdHJ5IExhYm9yYXRvcnkQUFJPR1JBTU1JTkcgSU4gQxZDb21wdXRhdGlvbmFsIFRoaW5raW5nEkhlcml0YWdlIG9mIFRhbWlscxhDT01NVU5JQ0FUSU9OIExBQk9SQVRPUlkYQyBQUk9HUkFNTUlORyBMQUJPUkFUT1JZFQoGU2VsZWN0BTIxMzI3BTIxMzI4BTIxMzI5BTIxMzMwBTIxMzMxBTIxMzMzBTIxMzM1BTIxMzM2BTIxMzM3FCsDCmdnZ2dnZ2dnZ2cWAWZkAgMPPCsAEQIBEBYAFgAWAAwUKwAAZAJRD2QWAgIJDwUyZnBzcHJlYWRzdGF0ZTpmMzFlY2JhNC1hZGQ5LTRmMzUtOWEyYi00OWJkNTgyNmU1MTVkAi8PZBYIAgcPZBYCZg9kFgICAQ8QZGQWAGQCDQ9kFgJmD2QWAgIBDw8WAh8ABQMxMDBkZAITD2QWAmYPZBYCAgEPEGQQFQEAFQEAFCsDAWcWAWZkAhkPZBYCZg9kFgICAQ8FMmZwc3ByZWFkc3RhdGU6Mzk1NjdkZGUtMTIzZi00NjAwLTk5NzItM2YyNDFlNWJiNDY1ZAI1D2QWAgIBD2QWBAIFDxBkZBYBZmQCCw9kFgICAQ8FMmZwc3ByZWFkc3RhdGU6OTI4Yzg5Y2MtNzM4MS00OWUzLTk3ZWYtM2I3ZmJjN2ZhMDA5ZAI3D2QWAgIBD2QWAgIBDwUyZnBzcHJlYWRzdGF0ZTo2MmRiYzA4Yy1jNWMyLTRjYTAtOTY0MS02YjVlNDkzYzgzYTBkGAgFDWd2aWV3aG9tZXdvcmsPZ2QFFUdyaWRWaWV3X0hvc3RlbFZhY2F0ZQ9nZAUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja0tleV9fFhwFC0Zwc3BlcnNvbmFsBQxGcHN0aW1ldGFibGUFCEZwc21hcmtzBRVQcmludGNvbnRyb2wkRnBGb290ZXIFC0ZwUXVlc3Rpb25zBQ5GcHF1ZXN0aW9uYmFuawUJRnBzbGVzc29uBQ1GcHNhdHRlbmRlbmNlBQlGcHNlbWF0ZW4FCkZwc2xpYnJhcnkFCUZwU3ByZWFkNAUJRnBTcHJlYWQyBRZQcmludGNvbnRyb2wxJEZwRm9vdGVyBQpGcHNnZW5lcmFsBQtGcHNwcmVhZGZlZQUJRnBzcHJlYWQ1BQZmcHRlc3QFCUZwU3ByZWFkMQUSRnBfc3R1ZGVudF9jb25kdWN0BQlGcFNwcmVhZDMFD3NwcmVhZF9xdWVzdGlvbgUJRnBzcHJlYWQ2BQVGcENFTwUKc3ByZWFkRGV0MwUNRnBTcHJlYWRTdGFmZgUMRnBTcHJlYWRCb29rBQ9pbWdub3RpZmljYXRpb24FCGxibG9nb3V0BQlHcmlkVmlldzUPZ2QFDmdyZGNvdW5zZWxsaW5nD2dkBQdncmRzaG93D2dkBQhTaG93Z3JpZA9nZAUOZ3ZpZXdwbGFjZW1lbnQPZ2R0ERrgf%2BmRoRvECrY1M9ie78hFoRQa3jsN%2FDhZDrbrRA%3D%3D&__VIEWSTATEGENERATOR=A56AD786&cpePersonal_ClientState=true&cpetimetable_ClientState=true&ImageButtoncam=CAM+Marks&cpemarks_ClientState=false&tbfrom=3-02-2024&tbto=3-02-2024&CollapsiblePanelExtender2_ClientState=true&cpeAttendence_ClientState=true&cpeLibrary_ClientState=true&cpeGeneral_ClientState=true&CollapsiblePanelExtender1_ClientState=&CollapsiblePanelExtender3_ClientState=&CollapsiblePanelExtender4_ClientState=&Accordion1_AccordionExtender_ClientState=0&CollapsiblePanelExtender6_ClientState=true&CollapsiblePanelExtender7_ClientState=true&CollapsiblePanelExtender8_ClientState=&CollapsiblePanelExtender9_ClientState=true&cpeOnlinePayment_ClientState=&cpeNoDues_ClientState=&scrollY=114';

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = <List<dynamic>>[];
      List<dynamic>? currentSemester;
      String? semesterName;

      final document = parser.parse(response.body);
      final rows = document.querySelectorAll('tr');
      for (var row in rows) {
        final cells = row.querySelectorAll('td[FpCellType="GeneralCellType"]');
        if (cells.length > 0) {
          final cellValues = cells.map((cell) => cell.text.trim()).toList();
          if (cellValues[0].startsWith('Semester')) {
            if (currentSemester != null && currentSemester[1].isNotEmpty) {
              data.add(currentSemester);
            }
            semesterName = cellValues[0];
            currentSemester = [semesterName, []];
          } else {
            if (cellValues.length < 6) {
              continue;
            }else if (cellValues[1] == ''){
              continue;
            }
            else{
            debugPrint('cellValues: $cellValues');
            final selectedValues = [
              cellValues[1],
              cellValues[2],
              cellValues[5],
            ];
            currentSemester?[1].add(selectedValues);
          }
          }
        }
      }
      if (currentSemester != null && currentSemester[1].isNotEmpty) {
        data.add(currentSemester);
      }

      printLongString('data - -- --  > > > > >> > > > > > >  ${data.toString()}');
      String jsonData = jsonEncode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', jsonData);
      return data;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Server is Busy'),
            content: Text('Try Again later'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard()));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      throw Exception('Failed to load marks');
    }
  }

  Widget cardWidget(String title, double percentage, Widget routeBuilder) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => routeBuilder));
      },
      child: Card(
        color: Color.fromARGB(255, 17, 5, 44)
            .withOpacity(0.2), // make the Card semi-transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 7,
        margin: EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 10),
            child: Container(
              alignment: Alignment.center,
              color: Color.fromARGB(5, 40, 43, 91).withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20), // adjust the value as needed
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$title:',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: Color.fromARGB(
                              255, 94, 183, 255), // make the text blue
                          fontSize: 22, // make the text a little big
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$percentage%', // display the percentage
                    style: TextStyle(
                      fontFamily: 'QuickSand',
                      fontSize: 32, // make the text bigger
                    ),
                  ),
                  SizedBox(height: 10), // add some spacing
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 3,
                      width: 120,
                      child: LinearProgressIndicator(
                        value: percentage / 100, // calculate the progress
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation(
                          percentage < 50
                              ? Colors.red
                              : Color.fromARGB(255, 0, 162,
                                  255), // set the color based on the percentage
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double hlen = MediaQuery.of(context).size.height;
    double wlen = MediaQuery.of(context).size.width;

   return FutureBuilder<List<List<dynamic>>>(
  future: _marksFuture,
  builder: (BuildContext context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
    body: Center(
      child: LoadingAnimationWidget.dotsTriangle(

        color: Colors.white,
        size: 200,
      ),
    ),); // Show a loading spinner while waiting for _marksFuture to complete
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}'); // Show an error message if there's an error loading _marksFuture
    } else {
      if (snapshot.data == null || snapshot.data!.isEmpty) {
  return Text('No data'); // Show a message if the data is empty
} else {
          List<List<dynamic>> data = snapshot.data!;
          List<String> titles = data.map((semesterData) {
            String fullTitle = semesterData[0] as String;
            String modifiedTitle = fullTitle.replaceAll('Semester', 'Sem');
            return modifiedTitle;
          }).toList();

          int count = titles.length;
  List<double> percentage = data.map((semesterData) {
    if (semesterData.length > 1 && semesterData[1] is List) {
      List<dynamic> values = semesterData[1] as List<dynamic>;
      List<double> numericValues = [];
      for (var element in values) {
        if (element is List && element.length > 2) {
          String value = element[2].toString();
          double? number = double.tryParse(value);
          if (number != null) {
            numericValues.add(number);
          }
        }
      }
      double sum = numericValues.fold(0.0, (value, element) => value + element);
      double average = numericValues.isNotEmpty ? sum / numericValues.length : 0.0;
      return double.parse(average.toStringAsFixed(1));
    } else {
      return 0.0; // Return a default value if semesterData has less than 2 elements or semesterData[1] is not a list
    }
  }).toList();
List<Widget> routes = titles.map((title) {
  return MarksDisplay(exam_name: title);
}).toList();

          // Return your widget here using the data
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back), // back button
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Center(
                child: Text(
                    'Exam Results'), // replace 'Marks' with your desired title
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh), // reload button
                  onPressed: () {
                  _getSessionId().then((sessionId) {
                    _getRedirectUrl().then((redirectUrl) {
                      fetchMarks(redirectUrl, sessionId).then((marks) {
                        setState(() {
                          _marksFuture = Future.value(marks);
                        });
                        
                        // Do something with marks
                        // return marks; // Can't return from void function
                      });
                    });
                  });
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 90, sigmaY: 130),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 0, 102).withOpacity(0),
                    ),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  height: hlen,
                  width: wlen,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/Dashboard.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 5),
                            child: Text(
                              'Choose the Exam:',
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'images/cap.png',
                                width: 40,
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Welcome, $name',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Add a GridView.builder
                          Container(
                            height: hlen *
                                0.7, // specify the height of the GridView
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // number of items per row
                              ),
                              itemCount: count,
                              itemBuilder: (context, index) {
                                // Define your data

                                // Pass the data to the cardWidget function
                                return cardWidget(
                                  titles[index],
                                  percentage[index],
                                  routes[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(30.0),
                    //   topRight: Radius.circular(30.0),
                    // ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 90, sigmaY: 130),
                      child: BottomNavigationBar(
                        backgroundColor: Color.fromARGB(255, 31, 0, 102)
                            .withOpacity(
                                0), // make the BottomNavigationBar semi-transparent
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Container(
                              decoration: _selectedIndex == 0
                                  ? BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue,

                                          blurRadius:
                                              20.0, // adjust the blur radius
                                          spreadRadius:
                                              2.0, // adjust the spread radius
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Image.asset(
                                'images/home.png',
                                height: 30,
                                width: 30,
                              ), // replace with your custom icon
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                              decoration: _selectedIndex == 1
                                  ? BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue,

                                          blurRadius:
                                              20.0, // adjust the blur radius
                                          spreadRadius:
                                              2.0, // adjust the spread radius
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Image.asset(
                                'images/timetable.png',
                                height: 30,
                                width: 30,
                              ), // replace with your custom icon
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                              decoration: _selectedIndex == 2
                                  ? BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue,
                                          blurRadius:
                                              20.0, // adjust the blur radius
                                          spreadRadius:
                                              2.0, // adjust the spread radius
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Image.asset(
                                'images/profile.png',
                                height: 30,
                                width: 30,
                              ), // replace with your custom icon
                            ),
                            label: '',
                          ),
                        ],
                        currentIndex: _selectedIndex < 0 ? 0 : _selectedIndex,
                        selectedItemColor: Colors.amber[800],
                        onTap: _onItemTapped,
                        showSelectedLabels:
                            false, // do not show labels for selected items
                        showUnselectedLabels:
                            false, // do not show labels for unselected items
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } 
    }
      },
    );
  }
}
