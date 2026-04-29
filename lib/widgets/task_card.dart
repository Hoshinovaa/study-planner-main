import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String deadline;
  final String status;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final Function(String)? onStatusChange;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.status,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
  });

  /// WARNA STATUS
  Color _getStatusColor() {
    switch (status) {
      case "SELESAI":
        return Colors.green;
      case "DALAM PENGERJAAN":
        return Colors.orange;
      case "BELUM DIKERJAKAN":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// POPUP MENU STATUS
  void _showStatusMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width,
        80,
        10,
        0,
      ),
      items: const [
        PopupMenuItem(value: "BELUM DIKERJAKAN", child: Text("Belum Dikerjakan")),
        PopupMenuItem(value: "DALAM PENGERJAAN", child: Text("Dalam Pengerjaan")),
        PopupMenuItem(value: "SELESAI", child: Text("Selesai")),
      ],
    );

    if (result != null && onStatusChange != null) {
      onStatusChange!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 5,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => _showStatusMenu(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// SUBTITLE
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 6),

                /// DEADLINE
                Text(
                  "Deadline: $deadline",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          /// ACTION BUTTON
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}