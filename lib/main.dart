import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://frvexfoezbscdbcvuxas.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZydmV4Zm9lemJzY2RiY3Z1eGFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDY4ODgsImV4cCI6MjA3NTMyMjg4OH0.XDr9MFxBMX0P42a4MwjstxtZeh_Caqdyrfpfr7d9ec8',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Личный кабинет',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  
  // Загрузка данных из Supabase
  Future<List<Map<String, dynamic>>> _loadMessages() async {
    try {
      final response = await _supabase
          .from('messages') // Ваша таблица
          .select()
          .order('created_at', ascending: false); // Сортировка по дате (новые сверху)
      
      return response;
    } catch (e) {
      throw Exception('Ошибка загрузки данных: $e');
    }
  }
  
  // Добавление новой записи
  Future<void> _addMessage() async {
    try {
      if (_messageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите сообщение')),
        );
        return;
      }
      
      await _supabase
          .from('messages') // Ваша таблица
          .insert({
            'message': _messageController.text, // Поле message
            'created_at': DateTime.now().toIso8601String(), // created_at добавится автоматически
          });
      
      // Очистка поля после успешного добавления
      _messageController.clear();
      
      // Обновление состояния
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сообщение добавлено')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  void _onButtonPressed() {
    setState(() {});
    print('Button pressed!');
  }

  Future<String> _loadBalance() async {
    await Future.delayed(const Duration(seconds: 2)); 
    return '1000₽';
  }

  // Функция для отображения формы добавления записи
  void _showAddMessageForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить сообщение'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Сообщение',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addMessage();
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Личный кабинет',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[300],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMessageForm,
            tooltip: 'Добавить сообщение',
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Первый контейнер с градиентом
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200,
                    Colors.lightBlue.shade200,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Добро пожаловать!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Row с тремя текстовыми элементами
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  Text(
                    'Настройки',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  Text(
                    'Помощь',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Второй контейнер с FutureBuilder для баланса
            Container(
              width: 280,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade300,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FutureBuilder<String>(
                future: _loadBalance(),
                builder: (context, snapshot) {
                  // Показываем индикатор загрузки
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  
                  // Если произошла ошибка
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ошибка загрузки',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Когда данные успешно загружены
                  return Center(
                    child: Text(
                      'Баланс: ${snapshot.data}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // FutureBuilder для отображения данных из Supabase
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Сообщения из базы данных:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _loadMessages(),
                    builder: (context, snapshot) {
                      // Проверка состояния подключения
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      // Проверка наличия ошибки
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Ошибка подключения: ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => setState(() {}),
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      // Проверка наличия данных
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Нет сообщений для отображения',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      
                      // Отображение данных
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final message = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                message['message']?.toString() ?? 'Нет сообщения',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                message['created_at'] != null 
                                    ? _formatDate(message['created_at'].toString())
                                    : 'Нет даты',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Секция с картинками
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Ваши игры:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container( 
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVTIXFG8H2WuK-41ws1aDq7LQ6zyARt3yjKg&s'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwV5kdZhn6WIMld7Lz9Zv6cp5fLS2oG95UiQ&s'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Секция профиля с кнопкой
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Мой профиль',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue.shade100,
                      ),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue.shade50,
                        backgroundImage: const NetworkImage(
                          'data:image/jpeg;base64,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',
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Изменить аватарку',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Кнопка добавления в нижней части экрана
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMessageForm,
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // Вспомогательная функция для форматирования даты
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}