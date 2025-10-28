import 'dart:async';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;

  // final String driverId;

  final Map<String, dynamic>? driverData;

  final String driverId;

  final String ownerId;

  final String ownerName;

  final String ownerProfile;

  const ChatScreen({
    super.key,

    required this.bookingId,

    required this.driverData,

    required this.driverId,

    required this.ownerId,

    required this.ownerName,

    required this.ownerProfile,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  Timer? _typingTimer;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _setupRealtimePresence();
    _setUserOnline();
    messageController.addListener(() => _handleTypingStatus());
  }

  void _setupRealtimePresence() async {
    final userId = await SharedPrefServices.getUserId();
    if (userId == null) return;

    final DatabaseReference rtdbRef = FirebaseDatabase.instance.ref();
    final userStatusDatabaseRef = rtdbRef.child("status/$userId");

    final onlineState = {
      "state": "online",
      "last_changed": ServerValue.timestamp,
    };
    final offlineState = {
      "state": "offline",
      "last_changed": ServerValue.timestamp,
    };

    final userStatusFirestoreRef = FirebaseFirestore.instance
        .collection('userStatus')
        .doc(userId);

    userStatusDatabaseRef.onDisconnect().set(offlineState);
    await userStatusDatabaseRef.set(onlineState);

    await userStatusFirestoreRef.set({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await userStatusDatabaseRef.onDisconnect().set(offlineState);
    await userStatusFirestoreRef.set({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // void _setUserOnline() async {
  //   final userId = await SharedPrefServices.getUserId();

  //   FirebaseFirestore.instance.collection('userStatus').doc(userId).set({
  //     'isOnline': true,

  //     'lastSeen': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  // void _setUserOffline() async {
  //   final userId = await SharedPrefServices.getUserId();

  //   FirebaseFirestore.instance.collection('userStatus').doc(userId).set({
  //     'isOnline': false,

  //     'lastSeen': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  Future<void> _setUserOnline() async {
    final userId = await SharedPrefServices.getUserId();
    if (userId == null || userId.isEmpty) return;

    await FirebaseFirestore.instance.collection('userStatus').doc(userId).set({
      'isOnline': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _setUserOffline() async {
    final userId = await SharedPrefServices.getUserId();
    if (userId == null || userId.isEmpty) return;

    await FirebaseFirestore.instance.collection('userStatus').doc(userId).set({
      'isOnline': false,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setUserOnline();
    } else {
      _setUserOffline();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _typingTimer?.cancel();

    _setUserOffline();

    messageController.dispose();

    super.dispose();
  }

  void _handleTypingStatus() {
    final currentUserId = SharedPrefServices.getUserId().toString();

    final typingRef = FirebaseFirestore.instance
        .collection('privateChats')
        .doc(widget.bookingId)
        .collection('typingStatus')
        .doc(currentUserId);

    if (messageController.text.trim().isNotEmpty) {
      typingRef.set({'isTyping': true});

      _typingTimer?.cancel();

      _typingTimer = Timer(const Duration(seconds: 2), () {
        typingRef.set({'isTyping': false});
      });
    } else {
      typingRef.set({'isTyping': false});
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,

      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      selectedImage = File(pickedFile.path);
    });
  }

  Future<void> _sendMessage() async {
    final messageText = messageController.text.trim();

    if (messageText.isEmpty && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a message or select an image."),

          behavior: SnackBarBehavior.floating,

          backgroundColor: Colors.redAccent,
        ),
      );

      return;
    }

    final senderId = await SharedPrefServices.getUserId();

    String imageUrl = '';

    // 🔹 Upload image if selected

    if (selectedImage != null) {
      final fileName =
          'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final ref = FirebaseStorage.instance.ref().child(fileName);

      await ref.putFile(selectedImage!);

      imageUrl = await ref.getDownloadURL();
    }

    // 🔹 Send Firestore message

    await FirebaseFirestore.instance
        .collection('privateChats')
        .doc(widget.bookingId)
        .collection('messages')
        .add({
          'message': messageText,

          'imageUrl': imageUrl,

          'senderId': senderId,

          'timestamp': FieldValue.serverTimestamp(),

          'status': 'sent',
        });

    messageController.clear();

    setState(() => selectedImage = null);
  }

  Future<void> _markAsSeen(DocumentSnapshot doc) async {
    final msgData = doc.data() as Map<String, dynamic>;

    final currentUserId = await SharedPrefServices.getUserId();

    if (msgData['senderId'] != currentUserId && msgData['status'] != 'seen') {
      doc.reference.update({'status': 'seen'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = SharedPrefServices.getUserId().toString();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleSpacing: 0,
          title: StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('drivers')
                    .doc(widget.driverId)
                    .snapshots(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage("images/person.png"),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Driver",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "(Offline)",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final driverName =
                  "${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}"
                      .trim();
              final driverProfile = userData['profileUrl'] ?? "";

              return Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        driverProfile.isNotEmpty
                            ? NetworkImage(driverProfile)
                            : const AssetImage("images/person.png")
                                as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName.isNotEmpty ? driverName : "Driver",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('userStatus')
                                .doc(widget.driverData!['userId'])
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Text(
                              "Offline",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }

                          final statusData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final bool isOnline = statusData['isOnline'] ?? false;
                          final Timestamp? lastSeen = statusData['lastSeen'];

                          if (isOnline) {
                            return Text(
                              "Online",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          } else if (lastSeen != null) {
                            final lastSeenDate = lastSeen.toDate();
                            final now = DateTime.now();

                            final difference =
                                now.difference(lastSeenDate).inDays;
                            final timeFormat = DateFormat(
                              'hh:mm a',
                            ).format(lastSeenDate);
                            String displayText;

                            if (difference == 0) {
                              displayText = "last seen today at $timeFormat";
                            } else if (difference == 1) {
                              displayText =
                                  "last seen yesterday at $timeFormat";
                            } else if (difference > 1 && difference <= 6) {
                              displayText =
                                  "last seen on ${DateFormat('EEEE').format(lastSeenDate)} at $timeFormat";
                            } else {
                              displayText =
                                  "last seen on ${DateFormat('MMM d, hh:mm a').format(lastSeenDate)}";
                            }

                            return Text(
                              displayText,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Text(
                              "Offline",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('privateChats')
                      .doc(widget.bookingId)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,

                  padding: const EdgeInsets.symmetric(vertical: 10),

                  itemCount: messages.length,

                  itemBuilder: (context, index) {
                    final doc = messages[index];

                    final msg = doc.data() as Map<String, dynamic>;

                    final bool isSentByMe = msg['senderId'] == currentUserId;

                    final timestamp = msg['timestamp'] as Timestamp?;

                    final messageTime =
                        timestamp != null ? timestamp.toDate() : DateTime.now();

                    final status = msg['status'] ?? 'sent';

                    final messageText = msg['message'] ?? '';

                    final imageUrl = msg['imageUrl'] ?? '';

                    _markAsSeen(doc);

                    return ChatBubble(
                      message: messageText,

                      imageUrl: imageUrl,

                      isSentByMe: isSentByMe,

                      timestamp: messageTime,

                      isDelivered: status == 'delivered' || status == 'seen',

                      isRead: status == 'seen',
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Image Preview (before sending)
          if (selectedImage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),

              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: Image.file(
                      selectedImage!,

                      width: 120,

                      height: 120,

                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 4,

                    right: 4,

                    child: GestureDetector(
                      onTap: () => setState(() => selectedImage = null),

                      child: const CircleAvatar(
                        radius: 12,

                        backgroundColor: Colors.black54,

                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,

                  blurRadius: 5,

                  offset: const Offset(0, -1),
                ),
              ],
            ),

            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_a_photo, color: Colors.grey),

                  onPressed: () {
                    showModalBottomSheet(
                      context: context,

                      builder:
                          (context) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,

                                    color: korangeColor,
                                  ),

                                  title: const Text("Camera"),

                                  onTap: () {
                                    Navigator.pop(context);

                                    _pickImage(ImageSource.camera);
                                  },
                                ),

                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library,

                                    color: korangeColor,
                                  ),

                                  title: const Text("Gallery"),

                                  onTap: () {
                                    Navigator.pop(context);

                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                    );
                  },
                ),

                Expanded(
                  child: TextField(
                    controller: messageController,

                    maxLines: null,

                    decoration: InputDecoration(
                      hintText: "Type a message...",

                      hintStyle: const TextStyle(color: Colors.grey),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),

                        borderSide: BorderSide.none,
                      ),

                      filled: true,

                      fillColor: Colors.grey.shade100,

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,

                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: _sendMessage,

                  child: CircleAvatar(
                    backgroundColor: korangeColor,

                    radius: 22,

                    child: const Icon(
                      Icons.send,

                      color: Colors.white,

                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String imageUrl;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isDelivered;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.message,
    required this.imageUrl,
    required this.isSentByMe,
    required this.timestamp,
    this.isDelivered = false,
    this.isRead = false,
  });

  String format12HourTime(DateTime dateTime) =>
      DateFormat('h:mm a').format(dateTime);

  @override
  Widget build(BuildContext context) {
    Widget tickIcon = const SizedBox();
    if (!isDelivered) {
      tickIcon = const Icon(Icons.done, size: 14, color: Colors.grey);
    } else if (isDelivered && !isRead) {
      tickIcon = const Icon(Icons.done_all, size: 14, color: Colors.grey);
    } else {
      tickIcon = const Icon(Icons.done_all, size: 14, color: Colors.blue);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSentByMe
                        ? const Color(0xFFE7FFDB)
                        : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isSentByMe ? 12 : 0),
                  bottomRight: Radius.circular(isSentByMe ? 0 : 12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isSentByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  if (imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 120,
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        format12HourTime(timestamp),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (isSentByMe) ...[const SizedBox(width: 4), tickIcon],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ChatBubble extends StatelessWidget {
//   final String message;

//   final String imageUrl;

//   final bool isSentByMe;

//   final DateTime timestamp;

//   final bool isDelivered;

//   final bool isRead;

//   const ChatBubble({
//     super.key,

//     required this.message,

//     required this.imageUrl,

//     required this.isSentByMe,

//     required this.timestamp,

//     this.isDelivered = false,

//     this.isRead = false,
//   });

//   String format12HourTime(DateTime dateTime) =>
//       DateFormat('h:mm a').format(dateTime);

//   @override
//   Widget build(BuildContext context) {
//     Widget tickIcon = const SizedBox();

//     if (!isDelivered) {
//       tickIcon = const Icon(Icons.done, size: 14, color: Colors.grey);
//     } else if (isDelivered && !isRead) {
//       tickIcon = const Icon(Icons.done_all, size: 14, color: Colors.grey);
//     } else {
//       tickIcon = const Icon(Icons.done_all, size: 14, color: Colors.blue);
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),

//       child: Align(
//         alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,

//         child: IntrinsicWidth(
//           child: Container(
//             padding: const EdgeInsets.all(10),

//             decoration: BoxDecoration(
//               color:
//                   isSentByMe
//                       ? const Color.fromARGB(255, 212, 252, 215)
//                       : Colors.grey[100],

//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(isSentByMe ? 12 : 0),

//                 topRight: Radius.circular(isSentByMe ? 0 : 12),

//                 bottomLeft: const Radius.circular(12),

//                 bottomRight: const Radius.circular(12),
//               ),
//             ),

//             child: Column(
//               crossAxisAlignment:
//                   isSentByMe
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,

//               children: [
//                 if (imageUrl.isNotEmpty)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),

//                     child: Image.network(
//                       imageUrl,

//                       width: 160,

//                       fit: BoxFit.cover,
//                     ),
//                   ),

//                 if (message.isNotEmpty) ...[
//                   const SizedBox(height: 5),

//                   Text(
//                     message,

//                     style: GoogleFonts.poppins(
//                       fontSize: 13,

//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 4),

//                 Row(
//                   mainAxisSize: MainAxisSize.min,

//                   mainAxisAlignment:
//                       isSentByMe
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.start,

//                   children: [
//                     Text(
//                       format12HourTime(timestamp),

//                       style: GoogleFonts.poppins(
//                         fontSize: 10,

//                         color: Colors.grey,
//                       ),
//                     ),

//                     if (isSentByMe) ...[const SizedBox(width: 4), tickIcon],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
