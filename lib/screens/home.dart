import 'package:flutter/material.dart';
import 'add_target_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  final List<String> _daysOfWeek = [
    "Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"
  ];

  int _getDaysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  int _getFirstDayOffset(int year, int month) =>
      DateTime(year, month, 1).weekday - 1;

  void _goToAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTargetScreen(),
      ),
    );
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
      ],
    );
  }

  // ================= SECTION HEADER =================
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Progress Tugas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ================= TASK LIST =================
  Widget _buildTaskList() {
    return SizedBox(
      height: 180,
      child: StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance
          .collection('tasks')
          .where(
            'uid',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada tugas"),
            );
          }

          final docs = snapshot.data!.docs;

          Map<String, List<Map<String, dynamic>>> groupedTasks = {};
          for (var doc in docs) {
            final task = doc.data() as Map<String, dynamic>;

            final course = task["course"] ?? "Tanpa Mata Kuliah";

            if (!groupedTasks.containsKey(course)) {
              groupedTasks[course] = [];
            }

            groupedTasks[course]!.add(task);
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groupedTasks.length,
            itemBuilder: (context, index) {
              final courseName =
                  groupedTasks.keys.elementAt(index);

              final tasks =
                  groupedTasks[courseName]!;

              final totalTask = tasks.length;

              final completedTask = tasks.where((task) {
                return task["status"] == "SELESAI";
              }).length;

              final double value =
                  totalTask == 0 ? 0 : completedTask / totalTask;

              final percent =
                  (value * 100).toInt();

              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            color: const Color(0xFF6A0DAD),
                            backgroundColor:
                                Colors.grey.shade200,
                          ),
                        ),
                        Text(
                          "$percent%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "$completedTask dari $totalTask tugas selesai",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "$percent%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: percent == 100
                                  ? Colors.green
                                  : Colors.deepPurple,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "$totalTask tugas",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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

              DateTime today = DateTime.now();

              DateTime currentDate = DateTime(
                _focusedDate.year,
                _focusedDate.month,
                day,
              );

              bool isPastDate = currentDate.isBefore(
                DateTime(today.year, today.month, today.day),
              );

              bool isSelected =
                  day == _selectedDate.day &&
                  _focusedDate.month == _selectedDate.month &&
                  _focusedDate.year == _selectedDate.year;

              return GestureDetector(
                onTap: isPastDate
                    ? null
                    : () {
                        setState(() {
                          _selectedDate = currentDate;
                        });
                      },
                child: Center(
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : isPastDate
                              ? Colors.grey.shade200
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$day",
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isPastDate
                                  ? Colors.grey
                                  : Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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