import 'dart:async';

import 'package:flutter/material.dart';

import '../../supabase_config.dart';

class CheckboxList extends StatefulWidget {
  final DateTime? date;
  final String? userId; //date to be passed to the db along with this data
  const CheckboxList({super.key, required this.date, this.userId});

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  bool toggleValue = false;
  bool isMorningSelected = false;
  bool isNoonSelected = false;
  bool isEveningSelected = false;

  @override
  void initState() {
    super.initState();

    // Get the current time
    DateTime currentTime = DateTime.now();

    // Deactivate Morning toggle button after 11 PM
    if (currentTime.hour >= 01) {
      setState(() {
        isMorningSelected = false;
      });
      // startStatusTimer(01,"food_morning","morning_food",isMorningSelected);
    }

    // Deactivate Noon toggle button after 9 AM
    if (currentTime.hour >= 9) {
      setState(() {
        isNoonSelected = false;
      });
      // startStatusTimer(9,"food_noon","noon_food",isNoonSelected);
    }

    // Deactivate Evening toggle button after 5 PM
    if (currentTime.hour >= 17) {
      setState(() {
        isEveningSelected = false;
      });
    }

    // Reset Morning toggle after 8 AM
    if (currentTime.hour >= 8) {
      Timer(const Duration(minutes: 1), () {
        setState(() {
          isMorningSelected = false;
        });
      });
    }

    // Reset Noon toggle after 2 PM
    if (currentTime.hour >= 14) {
      Timer(const Duration(minutes: 1), () {
        setState(() {
          isNoonSelected = false;
        });
      });
    }

    // Reset Evening toggle after 10 PM
    if (currentTime.hour >= 22) {
      Timer(const Duration(minutes: 1), () {
        setState(() {
          isEveningSelected = false;
        });
      });
    }

    // Schedule timer to reset the toggles at the start of the next day
    Timer(
      Duration(
        hours: 24 - currentTime.hour,
        minutes: 60 - currentTime.minute,
        seconds: 60 - currentTime.second,
      ),
      () {
        setState(() {
          isMorningSelected = false;
          isNoonSelected = false;
          isEveningSelected = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                )),
            leading: CircleAvatar(
                backgroundColor: Colors.blue[400],
                child: const Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                )),
            title: const Text('Morning'),
            trailing: Switch(
              value: isMorningSelected,
              activeColor: Colors.green,
              onChanged: canToggleMorning()
                  ? (value) async {
                      setState(() {
                        isMorningSelected = value;
                      });
                      print("Selected morning");
                      try {
                        final userId = widget.userId;
                        final date =
                            DateTime.now().toLocal().toString().split(' ')[0];
                  

                        final existingDataResponse = await supabase
                            .from('food_morning')
                            .select()
                            .eq('u_id', userId)
                            .eq('mark_date', date)
                            .execute();

                        if (existingDataResponse.error != null) {
                          // Handle error
                          throw existingDataResponse.error!;
                        }

                        final existingData = existingDataResponse.data;

                        if (existingData != null && existingData.length == 1) {
                          // Existing data found, perform update
                          final updateResponse = await supabase
                              .from('food_morning')
                              .update({
                                'morning_food': value,
                              })
                              .eq('u_id', userId)
                              .eq('mark_date', date)
                              .execute();

                          if (updateResponse.error != null) {
                            // Handle error
                            throw updateResponse.error!;
                          }

                          print('Update operation completed successfully!');
                        } else {
                          // No existing data, perform insert
                          final insertResponse =
                              await supabase.from('food_morning').insert([
                            {
                              'u_id': userId,
                              'mark_date': date,
                              'morning_food': value,
                            }
                          ]).execute();

                          if (insertResponse.error != null) {
                            // Handle error
                            throw insertResponse.error!;
                          }

                          print('Insert operation completed successfully!');
                        }
                      } catch (e) {
                        print('An error occurred: $e');
                      }
                    }
                  : null,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                )),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[400],
              child: const Icon(
                Icons.sunny,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Noon',
            ),
            trailing: Switch(
              value: isNoonSelected,
              activeColor: Colors.green,
              onChanged: canToggleNoon()
                  ? (value) async {
                      setState(() {
                        isNoonSelected = value;
                      });
                      print("Selected Noon");
                      try {
                        final userId = widget.userId;
                        final date =
                            DateTime.now().toLocal().toString().split(' ')[0];

                        final existingDataResponse = await supabase
                            .from('food_noon')
                            .select()
                            .eq('u_id', userId)
                            .eq('mark_date', date)
                            .execute();

                        if (existingDataResponse.error != null) {
                          // Handle error
                          throw existingDataResponse.error!;
                        }

                        final existingData = existingDataResponse.data;

                        if (existingData != null && existingData.length == 1) {
                          // Existing data found, perform update
                          final updateResponse = await supabase
                              .from('food_noon')
                              .update({
                                'noon_food': value,
                              })
                              .eq('u_id', userId)
                              .eq('mark_date', date)
                              .execute();

                          if (updateResponse.error != null) {
                            // Handle error
                            throw updateResponse.error!;
                          }

                          print('Update operation completed successfully!');
                        } else {
                          // No existing data, perform insert
                          final insertResponse =
                              await supabase.from('food_noon').insert([
                            {
                              'u_id': userId,
                              'mark_date': date,
                              'noon_food': value,
                            }
                          ]).execute();

                          if (insertResponse.error != null) {
                            // Handle error
                            throw insertResponse.error!;
                          }

                          print('Insert operation completed successfully!');
                        }
                      } catch (e) {
                        print('An error occurred: $e');
                      }
                    }
                  : null,
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                )),
            leading: CircleAvatar(
                backgroundColor: Colors.blue[400],
                child: const Icon(
                  Icons.nightlight_round,
                  color: Colors.white,
                )),
            title: const Text('Evening'),
            trailing: Switch(
              value: isEveningSelected,
              activeColor: Colors.green,
              onChanged: canToggleEvening()
                  ? (value) async {
                      setState(() {
                        isEveningSelected = value;
                      });
                      print("Selected Evening");
                      try {
                        final userId = widget.userId;
                        final date =
                            DateTime.now().toLocal().toString().split(' ')[0];

                        final existingDataResponse = await supabase
                            .from('food_evening')
                            .select()
                            .eq('u_id', userId)
                            .eq('mark_date', date)
                            .execute();

                        if (existingDataResponse.error != null) {
                          // Handle error
                          throw existingDataResponse.error!;
                        }

                        final existingData = existingDataResponse.data;

                        if (existingData != null && existingData.length == 1) {
                          // Existing data found, perform update
                          final updateResponse = await supabase
                              .from('food_evening')
                              .update({
                                'evening_food': value,
                              })
                              .eq('u_id', userId)
                              .eq('mark_date', date)
                              .execute();

                          if (updateResponse.error != null) {
                            // Handle error
                            throw updateResponse.error!;
                          }

                          print('Update operation completed successfully!');
                        } else {
                          // No existing data, perform insert
                          final insertResponse =
                              await supabase.from('food_evening').insert([
                            {
                              'u_id': userId,
                              'mark_date': date,
                              'evening_food': value,
                            }
                          ]).execute();

                          if (insertResponse.error != null) {
                            // Handle error
                            throw insertResponse.error!;
                          }

                          print('Insert operation completed successfully!');
                        }
                      } catch (e) {
                        print('An error occurred: $e');
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  bool canToggleMorning() {
    DateTime currentTime = DateTime.now();
    return currentTime.hour < 1; // Allow toggle before 1 PM
  }

  bool canToggleNoon() {
    DateTime currentTime = DateTime.now();
    return currentTime.hour < 9; // Allow toggle before 9 AM
  }

  bool canToggleEvening() {
    DateTime currentTime = DateTime.now();
    return currentTime.hour < 17; // Allow toggle before 5 PM
  }

  void startStatusTimer(int time, String db, String tb, bool isSelect) {
    Timer(Duration(hours: time), () async {
      if (!isSelect) {
        try {
          final userId = widget.userId;
          final date = DateTime.now().toLocal().toString().split(' ')[0];

          final response = await supabase
              .from(db) // Updated table name
              .update({tb: false}) // Updated column name
              .eq('u_id', userId)
              .eq('mark_date', date)
              .execute();

          if (response.error != null) {
            // Handle error
            throw response.error!;
          }

          print('Status updated to false automatically!');
        } catch (e) {
          print('An error occurred: $e');
        }
      }
    });
  }
}
