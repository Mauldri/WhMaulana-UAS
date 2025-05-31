import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<Map<String, dynamic>> chatList = [];

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  Future<void> _loadChatData() async {
    final String jsonString = await rootBundle
        .loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      chatList = jsonData.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'WhAzlansaja',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(
                    child: Text(
                      'Belum ada pencarian',
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ),
          Expanded(
            child: chatList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      final chat = chatList[index];
                      final messages = chat['messages'] as List;
                      final lastMessage = messages.isNotEmpty
                          ? messages.last['message']
                          : 'Belum ada chat';
                      final unreadCount = chat['unread_count'] ?? 0;
                      final fullName = chat['full_name'];

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PesanScreen(chatData: chat),
                            ),
                          );
                        },
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(chat['avatar']),
                            ),
                            if (fullName == 'Azlan, S.Kom., M.Kom.' &&
                                unreadCount > 0)
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(fullName),
                        subtitle: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          fullName == 'Azlan, S.Kom., M.Kom.'
                              ? '2 menit lalu'
                              : 'kemarin',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'Pembaruan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
        ],
      ),
    );
  }
}