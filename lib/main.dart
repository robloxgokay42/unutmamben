// lib/main.dart dosyanızdaki _ReminderFormPageState sınıfını aşağıdaki kod ile değiştirin.
// Bu güncelleme, hatırlatıcıyı kaydetme ve bildirim kurma mantığını ekler.

class _ReminderFormPageState extends State<ReminderFormPage> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDateTime;

  // Yeni hatırlatıcıyı kaydetme ve bildirim planlama fonksiyonu
  void _saveAndScheduleReminder() async {
    if (_textController.text.isEmpty || _selectedDateTime == null) {
      // TODO: Kullanıcıya uyarı göster (örneğin, snackbar ile)
      print('Lütfen hatırlatıcı metnini ve zamanını girin.');
      return;
    }

    // Yeni bir benzersiz ID oluştur
    final newReminderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Yeni hatırlatıcı nesnesini oluştur
    final newReminder = Reminder(
      id: newReminderId,
      type: ReminderType.text, // Şimdilik sadece metin
      content: _textController.text,
      reminderTime: _selectedDateTime!,
      isDone: false,
      isRepeating: false,
      isVoiced: false,
    );

    // Hatırlatıcıyı yerel Hive veritabanına kaydet
    final box = Hive.box<Reminder>('reminders');
    box.add(newReminder);
    print('Hatırlatıcı kaydedildi: ${newReminder.content}');

    // Bildirimi planla
    _scheduleNotification(newReminder);

    // Sayfadan geri dön
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // Tarih ve saat seçimi
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Yerel bildirimi planlama
  void _scheduleNotification(Reminder reminder) async {
    final scheduledTime = tz.TZDateTime.from(
      reminder.reminderTime,
      tz.local,
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reminder_channel',
      'Hatırlatıcılar',
      channelDescription: 'Planlanan hatırlatıcılar için bildirimler.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id.hashCode, // Benzersiz bir bildirim ID'si
      'Unutmam Ben!',
      reminder.content,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: reminder.id,
    );
    print('Bildirim planlandı: ${reminder.content} için ${scheduledTime}');
  }

  // Sayfa widget'ı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hatırlatıcı Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Hatırlatmak istediğin şeyi yaz...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions),
                      onPressed: () {
                        // TODO: Emoji klavyesini aç
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        // TODO: Sesli not kaydını başlat/durdur
                      },
                    ),
                  ],
                ),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            // Tarih ve saat seçimi butonu
            ElevatedButton.icon(
              onPressed: () => _selectDateTime(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDateTime == null
                    ? 'Tarih ve Saat Seç'
                    : '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAndScheduleReminder,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Hatırlatıcıyı Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

