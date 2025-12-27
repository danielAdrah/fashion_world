// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_widget/custom_appBar.dart';
import '../../common_widget/fashion_event_tile.dart';
import '../../common_widget/primary_button.dart';
import '../../controller/store_controller.dart';
import '../../models/fashion_event.dart';
import '../../theme.dart';

class DesignerEventsView extends StatefulWidget {
  const DesignerEventsView({super.key});

  @override
  State<DesignerEventsView> createState() => _DesignerEventsViewState();
}

class _DesignerEventsViewState extends State<DesignerEventsView> {
  final storeController = Get.put(StoreController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  String _selectedEventType = 'designer_showcase';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    storeController.fetchAllEvents();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _organizerController.dispose();
    _websiteController.dispose();
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
                    "MY EVENTS",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Add new event form
                _buildAddEventForm(width),
                SizedBox(height: 30),
                // My events list
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    "YOUR EVENTS",
                    style: TextStyle(
                      color: TColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: StreamBuilder<List<FashionEvent>>(
                    stream: storeController.getEventsForDesigner(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: TColor.primary));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 80,
                                  color: TColor.primary.withOpacity(0.7),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'No events found',
                                  style: TextStyle(
                                    color: TColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Create your first event or participate in existing ones',
                                  style: TextStyle(
                                    color: TColor.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var event = snapshot.data![index];
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

  Widget _buildAddEventForm(double width) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CREATE NEW EVENT",
              style: TextStyle(
                color: TColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter event title';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            // Event Type
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _selectedEventType,
                isExpanded: true,
                underline: Container(),
                dropdownColor: TColor.background,
                style: TextStyle(color: TColor.white),
                items: [
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
                    _selectedEventType = value ?? 'designer_showcase';
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            // Start Date
            _buildDateField('Start Date', _startDate, () => _selectDate(true)),
            SizedBox(height: 15),
            // End Date
            _buildDateField('End Date', _endDate, () => _selectDate(false)),
            SizedBox(height: 15),
            // Image URL
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
            ),
            SizedBox(height: 15),
            // Organizer
            TextFormField(
              controller: _organizerController,
              decoration: InputDecoration(
                labelText: 'Organizer',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter organizer name';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            // Website
            TextFormField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: TextStyle(color: TColor.white),
            ),
            SizedBox(height: 20),
            // Submit button
            Center(
              child: PrimaryButton(
                onTap: _submitEvent,
                title: "CREATE EVENT",
              ),
            ),
            // ElevatedButton(
            //   onPressed: _submitEvent,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: TColor.primary,
            //     padding: EdgeInsets.symmetric(vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     minimumSize: Size(double.infinity, 50),
            //   ),
            //   child: Text(
            //     'CREATE EVENT',
            //     style: TextStyle(
            //       color: TColor.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today,
                color: TColor.primary,
                size: 16,
              ),
              SizedBox(width: 10),
              Text(
                date != null ? DateFormat('dd/MM/yyyy').format(date) : label,
                style: TextStyle(
                  color: date != null
                      ? TColor.white
                      : TColor.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
          _startDate = pickedDate;
          // If end date is before start date, adjust it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        _showErrorDialog('Please select start date');
        return;
      }
      if (_endDate == null) {
        _showErrorDialog('Please select end date');
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        _showErrorDialog('End date cannot be before start date');
        return;
      }

      try {
        // Get current designer ID
        String designerId = storeController.auth.currentUser!.uid;

        // Create the event
        FashionEvent event = FashionEvent(
          id: '', // Will be generated by Firestore
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          startDate: _startDate!,
          endDate: _endDate!,
          eventType: _selectedEventType,
          imageUrl: _imageUrlController.text,
          organizer: _organizerController.text,
          website: _websiteController.text,
          designers: [designerId], // Add current designer to the event
          timestamp: Timestamp.now(),
          isFeatured: false, // Default to not featured
        );

        // Add the event
        await storeController.addEvent(event);

        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _imageUrlController.clear();
        _organizerController.clear();
        _websiteController.clear();
        setState(() {
          _startDate = null;
          _endDate = null;
        });

        // Show success message
        _showSuccessDialog('Event created successfully!');
      } catch (e) {
        _showErrorDialog('Error creating event: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColor.background,
        title: Text(
          'Error',
          style: TextStyle(color: TColor.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: TColor.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: TColor.primary)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColor.background,
        title: Text(
          'Success',
          style: TextStyle(color: TColor.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: TColor.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: TColor.primary)),
          ),
        ],
      ),
    );
  }
}
