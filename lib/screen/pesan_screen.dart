import 'package:flutter/material.dart';

class PesanScreen extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const PesanScreen({super.key, required this.chatData});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  late List<Map<String, dynamic>> messages;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ambil data pesan dari chatData
    messages = widget.chatData['messages'].cast<Map<String, dynamic>>();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        // Tambahkan pesan baru ke daftar pesan
        messages.add({'from': 1, 'message': message});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatData = widget.chatData;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 29,
        elevation: 2,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: AssetImage(chatData['avatar']),
            radius: 16,
          ),
          title: Text(
            chatData['full_name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text('06.30'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isFromUser = message['from'] == 1;

                return Row(
                  mainAxisAlignment: isFromUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isFromUser)
                      CircleAvatar(
                        backgroundImage: AssetImage(chatData['avatar']),
                        radius: 14,
                      ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isFromUser ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['message'],
                          style: TextStyle(
                            color: isFromUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (isFromUser)
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/gambar_dosen/maulana.jpg',
                        ),
                        radius: 14,
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketikkan pesan...',
                      hintStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 15.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
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
