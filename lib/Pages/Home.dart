import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:freeze/Configurations/CustomNavigationBar.dart';

import '../Configurations/ApiKey.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  bool isFrozen = true;
  List<dynamic> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCardData();
  }

  Future<void> _fetchCardData() async {
    try {
      final response = await http.get(Uri.parse(
          mockarooApiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _cards = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Error', 'Failed to load card data',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String formatCardNumber(String number) {
    number = number.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if ((i + 1) % 4 == 0 && i != number.length - 1) {
        buffer.write('\n');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cards.isEmpty
            ? const Center(
          child: Text(
            'No card data available.',
            style: TextStyle(color: Colors.white),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'select payment mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'choose your preferred payment method to make payment.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTab('pay', true),
                const SizedBox(width: 10),
                _buildTab('card', false),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'YOUR DIGITAL DEBIT CARD',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF414345),
                            Color(0xFF232526)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    'assets/img.png',
                                    height: 50,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      isFrozen
                                          ? '****\n****\n****\n****'
                                          : formatCardNumber(
                                          _cards[0]
                                          ['cardNumber']),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text('expiry ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15)),
                                    Text(
                                      isFrozen
                                          ? '**/**'
                                          : _cards[0]['expiry'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17),
                                    ),
                                    const SizedBox(height: 7),
                                    const Text('cvv ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15)),
                                    Text(
                                      isFrozen
                                          ? '***'
                                          : _cards[0]['cvv']
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text:
                                    '${_cards[0]['cardNumber']} | ${_cards[0]['expiry']} | ${_cards[0]['cvv']}'));
                                Get.snackbar(
                                  'Copied',
                                  'Card details copied!',
                                  snackPosition:
                                  SnackPosition.BOTTOM,
                                  backgroundColor: Colors.grey[900],
                                  colorText: Colors.white,
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.copy,
                                      color: Colors.red, size: 16),
                                  SizedBox(width: 6),
                                  Text('copy details',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/Rupay.png',
                                  height: 40,
                                  width: 100,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    if (isFrozen)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 6.0, sigmaY: 6.0),
                            child: Container(
                              color: Colors.black45.withOpacity(0.2),
                              alignment: Alignment.center,
                              child: const Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    "Card Frozen",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: Icon(
                          isFrozen
                              ? Icons.lock_outline
                              : null,
                          color: isFrozen
                              ? Colors.red
                              : Colors.blueGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFrozen = !isFrozen;
                          });
                          Get.snackbar(
                            isFrozen ? 'Frozen' : 'Unfrozen',
                            isFrozen
                                ? 'Card is now frozen.'
                                : 'Card is now unfrozen.',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 1),
                            colorText: Colors.grey,
                            backgroundColor: Colors.black26,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFrozen = !isFrozen;
                    });
                    Get.snackbar(
                      isFrozen ? 'Frozen' : 'Unfrozen',
                      isFrozen ? 'Card is now frozen.' : 'Card is now unfrozen.',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 1),
                      colorText: Colors.grey,
                      backgroundColor: Colors.black26,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.ac_unit,
                          color: isFrozen ? Colors.red : Colors.blueGrey),
                      const SizedBox(height: 4),
                      Text(
                        isFrozen ? 'unfreeze' : 'freeze',
                        style: TextStyle(
                          color: isFrozen ? Colors.red : Colors.blueGrey,
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.white : Colors.red),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
