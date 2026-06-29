// lib/features/chat/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFF57C00);

const LinearGradient _kOrangeGrad = LinearGradient(
  colors: [Color(0xFFFF9800), Color(0xFFF44336)],
  begin:  Alignment.topLeft,
  end:    Alignment.bottomRight,
);

// ── Mock data models ─────────────────────────────────────────

enum _ChatTab { inbox, buying, selling }

enum _ChatFilter { all, unread, important }

class _MockChat {
  const _MockChat({
    required this.id,
    required this.buyerName,
    required this.adTitle,
    required this.lastMessage,
    required this.timeAgo,
    required this.adImageAsset,
    required this.isBuying,
    this.unreadCount   = 0,
    this.isAdInactive  = false,
    this.isImportant   = false,
    this.sellerPhone,
  });
  final String  id;
  final String  buyerName;
  final String  adTitle;
  final String  lastMessage;
  final String  timeAgo;
  final String  adImageAsset;
  final bool    isBuying;
  final int     unreadCount;
  final bool    isAdInactive;
  final bool    isImportant;
  final String? sellerPhone;
}

const _buyingChats = <_MockChat>[
  _MockChat(
    id:           'c1',
    buyerName:    'Ramesh Patil',
    adTitle:      'Mahindra 575 DI XP Plus Tractor',
    lastMessage:  'Hello, is this still available?',
    timeAgo:      '2 hrs ago',
    adImageAsset: 'assets/images/tractor1.webp',
    isBuying:     true,
    unreadCount:  2,
    sellerPhone:  '9876543210',
  ),
  _MockChat(
    id:           'c2',
    buyerName:    'Suresh Jadhav',
    adTitle:      'Swaraj 744 FE Tractor',
    lastMessage:  'Mobile number : 9422380…',
    timeAgo:      '3 days ago',
    adImageAsset: 'assets/images/tractor2.webp',
    isBuying:     true,
    unreadCount:  1,
    sellerPhone:  '9422380000',
  ),
  _MockChat(
    id:           'c3',
    buyerName:    'Vijay More',
    adTitle:      '2 Acre Irrigated Farm Land',
    lastMessage:  'Messaged 3 days ago, reply?',
    timeAgo:      '5 days ago',
    adImageAsset: 'assets/images/land1.jpeg',
    isBuying:     true,
    isAdInactive: true,
  ),
  _MockChat(
    id:           'c4',
    buyerName:    'Anita Shinde',
    adTitle:      'Fresh Alphonso Mangoes',
    lastMessage:  'What is the price per dozen?',
    timeAgo:      '1 week ago',
    adImageAsset: 'assets/images/mango.jpeg',
    isBuying:     true,
    isImportant:  true,
  ),
];

const _sellingChats = <_MockChat>[
  _MockChat(
    id:           's1',
    buyerName:    'Pravin Kulkarni',
    adTitle:      'JCB Rental — Per Day',
    lastMessage:  'Can I rent for 3 days?',
    timeAgo:      '1 hr ago',
    adImageAsset: 'assets/images/jcb1.jpeg',
    isBuying:     false,
    unreadCount:  3,
    sellerPhone:  '9988776655',
  ),
  _MockChat(
    id:           's2',
    buyerName:    'Deepak Nair',
    adTitle:      'HF Cow — High Milk Yield',
    lastMessage:  'Is she vaccinated?',
    timeAgo:      '2 days ago',
    adImageAsset: 'assets/images/cow1.jpeg',
    isBuying:     false,
  ),
];

// ═══════════════════════════════════════════════════════════════
// CHAT SCREEN
// ═══════════════════════════════════════════════════════════════
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  _ChatFilter _filter = _ChatFilter.all;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  int get _totalUnread =>
      [..._buyingChats, ..._sellingChats]
          .fold(0, (s, c) => s + c.unreadCount);

  int _unreadFor(bool isBuying) {
    final list = isBuying ? _buyingChats : _sellingChats;
    return list.fold(0, (s, c) => s + c.unreadCount);
  }

  List<_MockChat> get _currentChats {
    List<_MockChat> base;
    switch (_tabCtrl.index) {
      case 0:  base = [..._buyingChats, ..._sellingChats]; break;
      case 1:  base = _buyingChats; break;
      default: base = _sellingChats; break;
    }
    switch (_filter) {
      case _ChatFilter.all:       return base;
      case _ChatFilter.unread:    return base.where((c) => c.unreadCount > 0).toList();
      case _ChatFilter.important: return base.where((c) => c.isImportant).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar:          _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          _buildQuickFilters(),
          Expanded(
            child: _currentChats.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding:          const EdgeInsets.fromLTRB(0, 8, 0, 32),
                    itemCount:        _currentChats.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 86,
                      color:  Colors.grey.shade200,
                    ),
                    itemBuilder: (ctx, i) => _ChatTile(
                      chat:       _currentChats[i],
                      showChip:   _tabCtrl.index == 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:           _kGreen,
      foregroundColor:           Colors.white,
      elevation:                 0,
      centerTitle:               true,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chats',
            style: TextStyle(
              fontSize:   20,
              fontWeight: FontWeight.w800,
              color:      Colors.white,
            ),
          ),
          if (_totalUnread > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                gradient:     _kOrangeGrad,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_totalUnread',
                style: const TextStyle(
                  fontSize:   11,
                  fontWeight: FontWeight.w800,
                  color:      Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── 3-tab bar ────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: _kGreen,
      child: TabBar(
        controller:           _tabCtrl,
        indicatorColor:       Colors.white,
        indicatorWeight:      3,
        labelColor:           Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.60),
        labelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500),
        tabs: [
          // ── Inbox ───────────────────────────────────────
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Inbox'),
                if (_totalUnread > 0) ...[
                  const SizedBox(width: 6),
                  _UnreadBadge(count: _totalUnread),
                ],
              ],
            ),
          ),
          // ── Buying ──────────────────────────────────────
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Buying'),
                if (_unreadFor(true) > 0) ...[
                  const SizedBox(width: 6),
                  _UnreadBadge(count: _unreadFor(true)),
                ],
              ],
            ),
          ),
          // ── Selling ─────────────────────────────────────
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Selling'),
                if (_unreadFor(false) > 0) ...[
                  const SizedBox(width: 6),
                  _UnreadBadge(count: _unreadFor(false)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick filters ────────────────────────────────────────
  Widget _buildQuickFilters() {
    return Container(
      decoration: BoxDecoration(
        color:  Colors.white,
        border: Border(
            bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            'Filters:',
            style: TextStyle(
              fontSize:   12,
              fontWeight: FontWeight.w700,
              color:      Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 10),
          _QuickFilter(
            label:    'All',
            selected: _filter == _ChatFilter.all,
            onTap:    () => setState(() => _filter = _ChatFilter.all),
          ),
          const SizedBox(width: 8),
          _QuickFilter(
            label:    'Unread',
            selected: _filter == _ChatFilter.unread,
            onTap:    () => setState(() => _filter = _ChatFilter.unread),
          ),
          const SizedBox(width: 8),
          _QuickFilter(
            label:    'Important',
            selected: _filter == _ChatFilter.important,
            onTap:    () => setState(() => _filter = _ChatFilter.important),
          ),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width:  120,
              height: 120,
              decoration: BoxDecoration(
                color:  _kGreen.withOpacity(0.08),
                shape:  BoxShape.circle,
                border: Border.all(
                    color: _kGreen.withOpacity(0.15), width: 2),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size:  52,
                color: _kGreen.withOpacity(0.55),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No chats yet',
              style: TextStyle(
                fontSize:   20,
                fontWeight: FontWeight.w800,
                color:      AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you contact a seller or a buyer\nmessages you, it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color:    Colors.grey.shade600,
                height:   1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CHAT TILE
// ─────────────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, this.showChip = false});
  final _MockChat chat;
  final bool      showChip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _ChatDetailScreen(chat: chat),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Ad thumbnail ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                chat.adImageAsset,
                width:         58,
                height:        58,
                fit:           BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder:  (_, __, ___) => Container(
                  width:  58,
                  height: 58,
                  decoration: BoxDecoration(
                    color:        Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey.shade400, size: 24),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Info column ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Name + time + menu
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                chat.buyerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:   15,
                                  fontWeight: chat.unreadCount > 0
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            // ── Buying / Selling chip (Inbox only) ──
                            if (showChip) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: chat.isBuying
                                      ? _kGreen.withOpacity(0.12)
                                      : _kOrange.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: chat.isBuying
                                        ? _kGreen.withOpacity(0.35)
                                        : _kOrange.withOpacity(0.35),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  chat.isBuying ? 'Buying' : 'Selling',
                                  style: TextStyle(
                                    fontSize:   10,
                                    fontWeight: FontWeight.w700,
                                    color:      chat.isBuying
                                        ? _kGreen
                                        : _kOrange,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        chat.timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color:    Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTapDown: (d) =>
                            _showTileMenu(context, d.globalPosition),
                        child: Icon(Icons.more_vert_rounded,
                            size: 18, color: Colors.grey.shade500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Ad title
                  Text(
                    chat.adTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w600,
                      color:      Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Last message + unread badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:   13,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: chat.isAdInactive
                                ? Colors.red.shade400
                                : chat.unreadCount > 0
                                    ? AppColors.textPrimary
                                    : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 6),
                        _UnreadBadge(count: chat.unreadCount),
                      ],
                    ],
                  ),

                  // Ad inactive warning
                  if (chat.isAdInactive) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color:        Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border:       Border.all(
                            color: Colors.red.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 12, color: Colors.red.shade400),
                          const SizedBox(width: 6),
                          Text(
                            'Ad inactive. This chat will be deleted.',
                            style: TextStyle(
                              fontSize:   11,
                              fontWeight: FontWeight.w600,
                              color:      Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Important star
                  if (chat.isImportant) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 13, color: _kOrange),
                        const SizedBox(width: 4),
                        Text(
                          'Marked important',
                          style: TextStyle(
                            fontSize:   11,
                            fontWeight: FontWeight.w600,
                            color:      _kOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTileMenu(BuildContext context, Offset position) async {
    final selected = await showMenu<String>(
      context:  context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      shape:     RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color:     Colors.white,
      items: [
        _menuItem('mark_important',
            chat.isImportant
                ? 'Remove from important'
                : 'Mark as important',
            chat.isImportant
                ? Icons.star_border_rounded
                : Icons.star_rounded),
        _menuItem('mark_unread', 'Mark as unread',
            Icons.mark_chat_unread_outlined),
        _menuItem('block', 'Block user', Icons.block_rounded),
        _menuItem('delete', 'Delete chat',
            Icons.delete_outline_rounded,
            isDestructive: true),
      ],
    );
    if (selected == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:         Text('Action: $selected'),
      backgroundColor: _kGreen,
      behavior:        SnackBarBehavior.floating,
      duration:        const Duration(seconds: 2),
    ));
  }

  PopupMenuItem<String> _menuItem(
    String value,
    String label,
    IconData icon, {
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? Colors.red.shade600 : AppColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                  color:      color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CHAT DETAIL SCREEN
// ─────────────────────────────────────────────────────────────
class _ChatDetailScreen extends StatefulWidget {
  const _ChatDetailScreen({required this.chat});
  final _MockChat chat;

  @override
  State<_ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<_ChatDetailScreen> {
  final _msgCtrl    = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_Msg> _messages = [
    _Msg(text: 'Hello, is this still available?',  isMe: false, time: '10:32 AM'),
    _Msg(text: 'Yes, it is. Are you interested?',  isMe: true,  time: '10:35 AM'),
    _Msg(text: 'What is the final price?',          isMe: false, time: '10:36 AM'),
    _Msg(text: 'Price is fixed as listed. No negotiation.',
        isMe: true, time: '10:38 AM'),
    _Msg(text: 'Can I come see it tomorrow?',       isMe: false, time: '10:40 AM'),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: text, isMe: true, time: _nowTime()));
    });
    _msgCtrl.clear();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve:    Curves.easeOut,
        );
      }
    });
  }

  String _nowTime() {
    final now  = DateTime.now();
    final h    = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m    = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  Future<void> _call() async {
    final phone = widget.chat.sellerPhone;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:  Text('No phone number available.'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F0),
      appBar:          _buildAppBar(context),
      body: Column(
        children: [
          _AdContextCard(chat: widget.chat),
          Expanded(
            child: ListView.builder(
              controller:  _scrollCtrl,
              padding:     const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount:   _messages.length,
              itemBuilder: (_, i) => _MessageBubble(msg: _messages[i]),
            ),
          ),
          _InputBar(controller: _msgCtrl, onSend: _sendMessage),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _kGreen,
      foregroundColor: Colors.white,
      elevation:       0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size:   22,
          color:  Colors.white,
          weight: 900.0,
        ),
        onPressed:   () => Navigator.of(context).pop(),
        splashRadius: 20,
        padding:      const EdgeInsets.all(6),
        constraints:  const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(
          shape:           const CircleBorder(),
          backgroundColor: Colors.white.withOpacity(0.12),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.chat.buyerName,
            style: const TextStyle(
              fontSize:   16,
              fontWeight: FontWeight.w800,
              color:      Colors.white,
            ),
          ),
          Text(
            widget.chat.adTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color:    Colors.white.withOpacity(0.80),
            ),
          ),
        ],
      ),
      actions: [
        if (widget.chat.sellerPhone != null)
          IconButton(
            tooltip:   'Call',
            onPressed: _call,
            icon: Container(
              width:  36,
              height: 36,
              decoration: BoxDecoration(
                color:        Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.call_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        PopupMenuButton<String>(
          icon:  const Icon(Icons.more_vert_rounded, color: Colors.white),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          onSelected: (v) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:         Text('Action: $v'),
              backgroundColor: _kGreen,
              behavior:        SnackBarBehavior.floating,
              duration:        const Duration(seconds: 2),
            ));
          },
          itemBuilder: (_) => [
            _popItem('view_ad',    'View Ad',     Icons.open_in_new_rounded),
            _popItem('block',      'Block user',  Icons.block_rounded),
            _popItem('report',     'Report',      Icons.flag_outlined),
            _popItem('clear_chat', 'Clear chat',  Icons.delete_sweep_outlined,
                isDestructive: true),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  PopupMenuItem<String> _popItem(
    String value,
    String label,
    IconData icon, {
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? Colors.red.shade600 : AppColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                  color:      color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AD CONTEXT CARD
// ─────────────────────────────────────────────────────────────
class _AdContextCard extends StatelessWidget {
  const _AdContextCard({required this.chat});
  final _MockChat chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              chat.adImageAsset,
              width:  48,
              height: 48,
              fit:    BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48, height: 48,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.adTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to view listing',
                  style: TextStyle(
                    fontSize:   11,
                    color:      _kGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MESSAGE BUBBLE
// ─────────────────────────────────────────────────────────────
class _Msg {
  const _Msg({
    required this.text,
    required this.isMe,
    required this.time,
  });
  final String text;
  final bool   isMe;
  final String time;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top:    4,
          bottom: 4,
          left:   msg.isMe ? 60 : 0,
          right:  msg.isMe ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? _kGreen : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft:     const Radius.circular(16),
            topRight:    const Radius.circular(16),
            bottomLeft:  Radius.circular(msg.isMe ? 16 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 14,
                color:    msg.isMe ? Colors.white : AppColors.textPrimary,
                height:   1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color:    msg.isMe
                        ? Colors.white.withOpacity(0.70)
                        : Colors.grey.shade500,
                  ),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.done_all_rounded,
                      size:  13,
                      color: Colors.white.withOpacity(0.80)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INPUT BAR
// ─────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback          onSend;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomPad),
      decoration: BoxDecoration(
        color:  Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset:     const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:        const Color(0xFFF5F7F5),
                borderRadius: BorderRadius.circular(24),
                border:       Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller:      controller,
                textInputAction: TextInputAction.send,
                onSubmitted:     (_) => onSend(),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText:       'Type a message…',
                  hintStyle:      TextStyle(color: Colors.grey.shade500),
                  border:         InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width:  46,
              height: 46,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// UNREAD BADGE
// ─────────────────────────────────────────────────────────────
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      height:  20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient:     _kOrangeGrad,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(
            color:      Colors.white,
            fontSize:   10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK FILTER CHIP
// ─────────────────────────────────────────────────────────────
class _QuickFilter extends StatelessWidget {
  const _QuickFilter({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String       label;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color:        selected ? _kGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _kGreen : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:      _kGreen.withOpacity(0.25),
                    blurRadius: 6,
                    offset:     const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w700,
            color:      selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}