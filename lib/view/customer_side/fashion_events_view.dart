// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/fashion_event_tile.dart';
import '../../controller/store_controller.dart';
import '../../theme.dart';

class FashionEventsView extends StatefulWidget {
  const FashionEventsView({super.key});

  @override
  State<FashionEventsView> createState() => _FashionEventsViewState();
}

class _FashionEventsViewState extends State<FashionEventsView> {
  final storeController = Get.put(StoreController());
  final TextEditingController _searchController = TextEditingController();
  String _selectedEventType = 'all';
  String _selectedLocation = 'all';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    storeController.fetchAllEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/img/bg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomAppBar(),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "FASHION EVENTS",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Search and filter section
                _buildSearchAndFilterSection(width),
                SizedBox(height: 20),
                // Events list
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Obx(
                    () {
                      if (storeController.allEvents.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              Text(
                                'No events available yet!',
                                style: TextStyle(
                                  color: TColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Apply filters and create filtered list
                      List eventsList = [];
                      for (var event in storeController.allEvents) {
                        bool matchesSearch = true;
                        bool matchesEventType = true;
                        bool matchesLocation = true;
                        bool matchesStartDate = true;
                        bool matchesEndDate = true;

                        // Apply search filter
                        if (_searchController.text.isNotEmpty) {
                          matchesSearch = event.title.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              event.description.toLowerCase().contains(
                                  _searchController.text.toLowerCase());
                        }

                        // Apply event type filter
                        if (_selectedEventType != 'all') {
                          matchesEventType =
                              event.eventType == _selectedEventType;
                        }

                        // Apply location filter
                        if (_selectedLocation != 'all') {
                          matchesLocation = event.location
                              .toLowerCase()
                              .contains(_selectedLocation.toLowerCase());
                        }

                        // Apply start date filter
                        if (_selectedStartDate != null) {
                          matchesStartDate =
                              !event.startDate.isBefore(_selectedStartDate!);
                        }

                        // Apply end date filter
                        if (_selectedEndDate != null) {
                          matchesEndDate =
                              !event.endDate.isAfter(_selectedEndDate!);
                        }

                        // Add to list if all filters match
                        if (matchesSearch &&
                            matchesEventType &&
                            matchesLocation &&
                            matchesStartDate &&
                            matchesEndDate) {
                          eventsList.add(event);
                        }
                      }

                      // Check if filtered list is empty
                      if (eventsList.isEmpty &&
                          (_searchController.text.isNotEmpty ||
                              _selectedEventType != 'all' ||
                              _selectedLocation != 'all' ||
                              _selectedStartDate != null ||
                              _selectedEndDate != null)) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 80,
                                  color: TColor.primary.withOpacity(0.7),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'No events match your selected filters',
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Try adjusting your filters to see more events',
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _selectedEventType = 'all';
                                      _selectedLocation = 'all';
                                      _selectedStartDate = null;
                                      _selectedEndDate = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColor.primary,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Clear Filters',
                                    style: TextStyle(
                                      color: TColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Return the filtered events list
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: eventsList.length,
                        itemBuilder: (context, index) {
                          var event = eventsList[index];
                          return FashionEventTile(event: event);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection(double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: Icon(Icons.search, color: TColor.primary),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            style: TextStyle(color: TColor.white),
            onChanged: (value) {
              setState(() {}); // Rebuild to apply search filter
            },
          ),
          SizedBox(height: 15),
          // Filter options
          Text(
            'Filters',
            style: TextStyle(
              color: TColor.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          // Event type filter
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButton<String>(
              value: _selectedEventType,
              isExpanded: true,
              underline: Container(),
              dropdownColor: TColor.background,
              style: TextStyle(color: TColor.white),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All Event Types'),
                ),
                DropdownMenuItem(
                  value: 'fashion_week',
                  child: Text('Fashion Week'),
                ),
                DropdownMenuItem(
                  value: 'designer_showcase',
                  child: Text('Designer Showcase'),
                ),
                DropdownMenuItem(
                  value: 'virtual_show',
                  child: Text('Virtual Show'),
                ),
                DropdownMenuItem(
                  value: 'retail_event',
                  child: Text('Retail Event'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedEventType = value ?? 'all';
                });
              },
            ),
          ),
          SizedBox(height: 10),
          // Location filter
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButton<String>(
              value: _selectedLocation,
              isExpanded: true,
              underline: Container(),
              dropdownColor: TColor.background,
              style: TextStyle(color: TColor.white),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All Locations'),
                ),
                DropdownMenuItem(
                  value: 'new_york',
                  child: Text('New York'),
                ),
                DropdownMenuItem(
                  value: 'paris',
                  child: Text('Paris'),
                ),
                DropdownMenuItem(
                  value: 'london',
                  child: Text('London'),
                ),
                DropdownMenuItem(
                  value: 'milan',
                  child: Text('Milan'),
                ),
                DropdownMenuItem(
                  value: 'online',
                  child: Text('Online'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value ?? 'all';
                });
              },
            ),
          ),
          SizedBox(height: 10),
          // Date range picker
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: 'Start Date',
                  date: _selectedStartDate,
                  onTap: () => _selectDate(true),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildDateButton(
                  label: 'End Date',
                  date: _selectedEndDate,
                  onTap: () => _selectDate(false),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Clear filters button
          TextButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedEventType = 'all';
                _selectedLocation = 'all';
                _selectedStartDate = null;
                _selectedEndDate = null;
              });
            },
            child: Text(
              'Clear Filters',
              style: TextStyle(color: TColor.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              color: TColor.primary,
              size: 16,
            ),
            SizedBox(width: 5),
            Text(
              date != null ? DateFormat('dd/MM/yyyy').format(date) : label,
              style: TextStyle(
                color:
                    date != null ? TColor.white : TColor.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primary,
              onPrimary: TColor.white,
              surface: TColor.background,
              onSurface: TColor.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }
}
