import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final JitsiMeetController _jitsiMeetController = JitsiMeetController();

  @override
  void initState() {
    super.initState();
    _jitsiMeetController.addListener(_onJitsiMeetEvent);
  }

  @override
  void dispose() {
    super.dispose();
    _jitsiMeetController.removeListener(_onJitsiMeetEvent);
  }

  void _onJitsiMeetEvent(JitsiMeetEvent event) {
    print("JitsiMeetEvent: $event");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: JitsiMeetView(
        controller: _jitsiMeetController,
        room: 'your-room-name',
      ),
    );
  }
}