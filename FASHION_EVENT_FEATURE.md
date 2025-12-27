# Fashion Event Integration Feature

## Overview

The Fashion Event Integration feature enhances the Fashion World app by adding comprehensive event management capabilities for both customers and designers. This feature allows users to discover, browse, and manage fashion-related events such as fashion weeks, designer showcases, virtual shows, and retail events.

## Features Implemented

### 1. Data Models

- **FashionEvent Model**: Complete data structure for storing event information including title, description, location, dates, type, images, organizer, website, participating designers, and featured status.

### 2. Services

- **EventService**: Comprehensive service for managing fashion events with CRUD operations and specialized queries for different event types, locations, dates, and designer participation.

### 3. User Interface Components

- **FashionEventTile Widget**: Visually appealing tile component for displaying event information with images, dates, location, description, and action buttons.
- **FashionEventsView**: Customer-facing view with search and filtering capabilities (by event type, location, date range).
- **DesignerEventsView**: Designer-facing view with form for creating new events and displaying events the designer is participating in.

### 4. Integration Points

- Added "Events" buttons to both customer and designer home pages for easy access.
- Integrated with existing StoreController to manage event state and operations.

## Key Functionality

### For Customers:

- Browse all fashion events
- Search events by title or description
- Filter events by type (fashion week, designer showcase, virtual show, retail event)
- Filter events by location
- Filter events by date range
- View detailed event information
- Access event websites

### For Designers:

- Create new fashion events
- View events they're participating in
- Manage their event participation
- Input complete event details (title, description, location, dates, images, etc.)

## Technical Implementation

### Data Structure

```dart
class FashionEvent {
  String id;
  String title;
  String description;
  String location;
  DateTime startDate;
  DateTime endDate;
  String eventType; // fashion_week, designer_showcase, virtual_show, retail_event
  String imageUrl;
  String organizer;
  String website;
  List<String> designers; // List of designer IDs participating
  Timestamp timestamp;
  bool isFeatured;
}
```

### Service Methods

- `addEvent(FashionEvent event)`: Add a new fashion event
- `getAllEvents()`: Get all events with real-time updates
- `getFeaturedEvents()`: Get featured events
- `getEventsByType(String eventType)`: Get events by type
- `getEventsByDateRange(DateTime start, DateTime end)`: Get events by date range
- `getEventsByLocation(String location)`: Get events by location
- `getEventsForDesigner(String designerId)`: Get events for a specific designer
- `updateEvent(String eventId, Map<String, dynamic> data)`: Update an event
- `deleteEvent(String eventId)`: Delete an event
- `getEventById(String eventId)`: Get a specific event by ID

### UI Components

- Responsive event tiles with images and key information
- Advanced filtering and search capabilities
- Form validation for event creation
- Date pickers for event scheduling
- Dropdown selectors for event types and locations

## File Structure Added

```
lib/
├── models/
│   └── fashion_event.dart          # Event data model
├── services/
│   └── event_service.dart          # Event management service
├── common_widget/
│   └── fashion_event_tile.dart     # Event display widget
├── view/
│   ├── customer_side/
│   │   └── fashion_events_view.dart # Customer events view
│   └── deigner_side/
│       └── designer_events_view.dart # Designer events view
├── utils/
│   └── sample_events.dart          # Sample data utility
└── FASHION_EVENT_FEATURE.md        # This documentation
```

## How to Use

### For Customers:

1. Navigate to the Events section from the home page
2. Browse events or use search/filter options
3. Tap on any event to view details
4. Use the "Learn More" button to visit event websites

### For Designers:

1. Navigate to the Events section from the designer home page
2. Use the form to create new events
3. View events you're participating in
4. Manage your event participation

## Integration with Existing Features

- Works seamlessly with existing authentication system
- Integrates with the StoreController for state management
- Uses the same theming and styling as the rest of the app
- Compatible with existing navigation patterns

## Future Enhancements

- Push notifications for upcoming events
- Event RSVP functionality
- Social sharing of events
- Integration with calendar apps
- Real-time event updates
- Event feedback and rating system
- Video streaming for virtual events

## Dependencies Added

- `intl` package for date formatting

## Testing Considerations

- Test event creation form validation
- Verify real-time updates work correctly
- Test filtering and search functionality
- Ensure responsive design works on different screen sizes
- Test integration with existing navigation
