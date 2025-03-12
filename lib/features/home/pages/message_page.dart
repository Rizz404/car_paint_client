import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/static_chat_notif.dart';
import 'package:paint_car/features/home/pages/chat_detail_message.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class MessagePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const MessagePage());
  const MessagePage({super.key});
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data mock untuk bengkel dan chat
  late List<Bengkel> _bengkelList;
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initMockData();
  }

  void _initMockData() {
    _bengkelList = [
      Bengkel(
        id: '1',
        name: 'Bengkel Jaya Jaya Jaya',
        logoAsset: "assets/images/workshop/automotive.png",
        status: 'Online',
        messages: [
          ChatMessage(
            text: 'Selamat pagi Sob! Kira-kira mau naro mobil hari apa ya Sob?',
            isMe: false,
            time: '07:00',
          ),
          ChatMessage(
            text: 'Pagi, hari ini rada soreean bisa? bengkel tutup jam brp?',
            isMe: true,
            time: '07:05',
          ),
          ChatMessage(
            text: 'Bisa sore om, kita tutup jam 18:00 hari ini om',
            isMe: false,
            time: '07:10',
          ),
          ChatMessage(
            text: 'Oke om terima kasih',
            isMe: true,
            time: '07:15',
          ),
        ],
      ),
      Bengkel(
        id: '2',
        name: 'Bengkel Speedshop',
        logoAsset: "assets/images/workshop/automotive.png",
        status: 'Offline',
        messages: [
          ChatMessage(
            text: 'Om mau info mobilnya sudah...',
            isMe: false,
            time: '09:30',
          ),
        ],
      ),
      Bengkel(
        id: '3',
        logoAsset: "assets/images/workshop/automotive.png",
        name: 'Bengkel Jaya Mandiri 2',
        status: 'Online',
        messages: [
          ChatMessage(
            text: 'Lagi proses pengecatan Om',
            isMe: false,
            time: '10:15',
          ),
        ],
      ),
      Bengkel(
        id: '4',
        name: 'Bengkel Subar Subur',
        logoAsset: "assets/images/workshop/automotive.png",
        status: 'Offline',
        messages: [
          ChatMessage(
            text: 'Sehari lagi selesai Om',
            isMe: false,
            time: '11:45',
          ),
        ],
      ),
      Bengkel(
        id: '5',
        name: 'Bengkel Warna Indah',
        logoAsset: "assets/images/workshop/automotive.png",
        status: 'Online',
        messages: [
          ChatMessage(
            text: 'Terima kasih Om 🙏',
            isMe: false,
            time: '14:20',
          ),
        ],
      ),
      Bengkel(
        id: '6',
        name: 'Bengkel Hari Jaya',
        logoAsset: "assets/images/workshop/automotive_2.png",
        status: 'Offline',
        messages: [
          ChatMessage(
            text: 'Sama sama Om',
            isMe: false,
            time: '16:30',
          ),
        ],
      ),
    ];
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Pengecetan dengan no. order 121212121',
        time: 'Now',
      ),
      NotificationItem(
        id: '2',
        title: 'Promo Ramadan NIKKEN untuk...',
        time: 'Now',
      ),
      NotificationItem(
        id: '3',
        title: 'Pengecetan dengan no. order 121212121',
        time: 'Now',
      ),
      NotificationItem(
        id: '4',
        title: 'Promo Ramadan NIKKEN untuk...',
        time: 'Now',
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'Pengecetan dengan no. order 121212121',
        time: 'Now',
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        title: 'Promo Ramadan NIKKEN untuk...',
        time: 'Now',
        isRead: true,
      ),
      NotificationItem(
        id: '7',
        title: 'Pengecetan dengan no. order 121212121',
        time: 'Now',
        isRead: true,
      ),
      NotificationItem(
        id: '8',
        title: 'Promo Ramadan NIKKEN untuk...',
        time: 'Now',
        isRead: true,
      ),
      NotificationItem(
        id: '9',
        title: 'Pengecetan dengan no. order 121212121',
        time: 'Now',
        isRead: true,
      ),
    ];
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Messages'),
                Tab(text: 'Notifications'),
              ],
              labelColor: CustomColors.secondaryBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: CustomColors.secondaryBlue,
              indicatorWeight: 3,
            ),
          ),

          // Tab Content
          Container(
            child: SizedBox(
              height: MediaQuery.of(context)
                  .size
                  .height, // Adjust height for status bar
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Messages Tab
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bengkelList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1)
                            .paddingSymmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final bengkel = _bengkelList[index];
                      final lastMessage = bengkel.messages.last;
                      return _buildBengkelItem(
                        bengkel: bengkel,
                        logoAsset: bengkel.logoAsset,
                        nama: bengkel.name,
                        pesan: lastMessage.text,
                        waktu: _getTimeDisplay(lastMessage.time),
                        notifCount: index == 0 ? 1 : null,
                        onTap: () {
                          // Navigasi ke detail pesan
                          Navigator.push(
                            context,
                            ChatDetailPage.route(bengkel),
                          );
                        },
                      );
                    },
                  ),

                  // Notifications Tab
                  _notifications.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              MainText(
                                text: 'Belum ada notifikasi',
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _notifications.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFEEEEEE),
                          ),
                          itemBuilder: (context, index) {
                            final notif = _notifications[index];
                            return _buildNotificationItem(
                              notification: notif,
                              onTap: () {
                                setState(() {
                                  // Mark notification as read when tapped
                                  _notifications[index] = NotificationItem(
                                    id: notif.id,
                                    title: notif.title,
                                    time: notif.time,
                                    isRead: true,
                                  );
                                });
                                // Handle notification tap
                                // You could navigate to a specific page based on notification type
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ).paddingSymmetric(vertical: 24),
    );
  }

  Widget _buildNotificationItem({
    required NotificationItem notification,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: notification.isRead ? Colors.white : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue dot for unread notifications
            if (!notification.isRead) ...[
              Container(
                margin: const EdgeInsets.only(top: 7, right: 8),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: CustomColors.secondaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ] else ...[
              const SizedBox(width: 16), // Placeholder for alignment
            ],

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    text: notification.title,
                    customTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: notification.isRead ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  MainText(
                    text: notification.time,
                    customTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeDisplay(String time) {
    // Contoh sederhana, seharusnya ada logika untuk menentukan 22m, 22h, 2d dll
    // berdasarkan selisih waktu pesan dengan waktu sekarang
    if (_bengkelList.indexOf(
            _bengkelList.firstWhere((b) => b.messages.last.time == time)) <
        2) {
      return '22m';
    } else if (_bengkelList.indexOf(
            _bengkelList.firstWhere((b) => b.messages.last.time == time)) <
        4) {
      return '22h';
    } else {
      return '2d';
    }
  }

  Widget _buildBengkelItem({
    required Bengkel bengkel,
    required String logoAsset,
    required String nama,
    required String pesan,
    required String waktu,
    int? notifCount,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            logoAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.car_repair, color: Colors.grey),
          ),
        ),
      ),
      title: MainText(
        text: nama,
        customTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: MainText(
        text: pesan,
        customTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MainText(
            text: waktu,
            customTextStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          if (notifCount != null) ...[
            const SizedBox(height: 4),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: CustomColors.secondaryBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: MainText(
                  text: notifCount.toString(),
                  customTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
