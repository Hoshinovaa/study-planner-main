import 'package:flutter/material.dart';
import 'add_target_screen.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _myTasks = [
    {
      "title": "Aplikasi Perangkat Bergerak",
      "percent": "90%",
      "value": 0.9,
      "isDone": false,
      "subTasks": [
        {"name": "Progres Tubes", "date": "18 April 2026", "time": "23:59"},
        {"name": "Tugas Individu 5", "date": "6 April 2026", "time": "23:59"},
      ],
    },
    {
      "title": "Sistem Cerdas",
      "percent": "40%",
      "value": 0.4,
      "isDone": false,
      "subTasks": [
        {"name": "Tugas Kelompok 1", "date": "10 April 2026", "time": "12:00"},
      ],
    },
    {
      "title": "Penetrasi dan Pengujian Etika Peretasan",
      "percent": "100%",
      "value": 1.0,
      "isDone": true,
      "subTasks": [],
    },
  ];

  final List<String> _daysOfWeek = [
    "Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"
  ];

  int _getDaysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  int _getFirstDayOffset(int year, int month) =>
      DateTime(year, month, 1).weekday - 1;

  void _goToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTargetScreen()),
    );

    if (result != null) {
      setState(() => _myTasks.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildCalendarCard(),
                const SizedBox(height: 25),
                _buildSectionHeader(),
                const SizedBox(height: 15),
                _buildTaskList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Halo, SUNNY 😊",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Selamat Belajar Bestie."),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= SECTION HEADER =================
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Target Hari Ini",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _goToAddTask,
          icon: const Icon(Icons.add_circle, color: Color(0xFF6A0DAD), size: 30),
        ),
      ],
    );
  }

  // ================= TASK LIST =================
  Widget _buildTaskList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _myTasks.length,
        itemBuilder: (context, index) {
          final task = _myTasks[index];
          bool isDone = task["isDone"] ?? false;

          return Stack(
            children: [
              Container(
                width: 280,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    isDone
                        ? const Icon(Icons.wb_sunny,
                            size: 55, color: Colors.orange)
                        : _buildProgressCircle(task),
                    const SizedBox(width: 15),
                    _buildTaskDetails(task, isDone),
                  ],
                ),
              ),
              if (isDone)
                Positioned(
                  right: 10,
                  top: 5,
                  child: IconButton(
                    icon: const Icon(Icons.cancel,
                        color: Colors.red, size: 20),
                    onPressed: () =>
                        setState(() => _myTasks.removeAt(index)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressCircle(Map<String, dynamic> task) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: task["value"],
            strokeWidth: 8,
            color: const Color(0xFF6A0DAD),
            backgroundColor: Colors.grey[200],
          ),
        ),
        Text(task["percent"],
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTaskDetails(Map<String, dynamic> task, bool isDone) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task["title"],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          isDone
              ? const Text(
                  "Mantappp\nUdah kelar tugas nya bestie",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                )
              : Column(
                  children: (task["subTasks"] as List)
                      .map(
                        (sub) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 12, color: Color(0xFF6A0DAD)),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(sub["name"],
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      "${sub["date"]} - ${sub["time"]}",
                                      style: const TextStyle(
                                          fontSize: 8, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }

  // ================= CALENDAR =================
  Widget _buildCalendarCard() {
    int daysInMonth =
        _getDaysInMonth(_focusedDate.year, _focusedDate.month);
    int offset =
        _getFirstDayOffset(_focusedDate.year, _focusedDate.month);

    List<String> months = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(
                        _focusedDate.year, _focusedDate.month - 1);
                  });
                },
              ),
              Text(
                "${months[_focusedDate.month]} ${_focusedDate.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedDate = DateTime(
                        _focusedDate.year, _focusedDate.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _daysOfWeek
                .map((day) => Text(day,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)))
                .toList(),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: daysInMonth + offset,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox.shrink();

              int day = index - offset + 1;

              bool isSelected =
                  day == _selectedDate.day &&
                      _focusedDate.month == _selectedDate.month &&
                      _focusedDate.year == _selectedDate.year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = DateTime(
                        _focusedDate.year, _focusedDate.month, day);
                  });
                },
                child: Center(
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$day",
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}