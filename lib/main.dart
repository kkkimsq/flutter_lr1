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
      home: const AuthScreen(), // Начинаем с экрана авторизации
    );
  }
}

// Экран авторизации
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка авторизации: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Заголовок
              Text(
                'Вход в аккаунт',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Введите ваши данные для входа',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Поле email
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Поле пароля
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Кнопка входа
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Войти',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Ссылка на регистрацию
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Нет аккаунта?',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _navigateToRegister,
                    child: Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Экран регистрации
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не совпадают')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароль должен содержать минимум 6 символов')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация успешна! Теперь войдите в аккаунт.')),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка регистрации: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToLogin,
        ),
        title: const Text('Регистрация'),
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Заголовок
              Text(
                'Создать аккаунт',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Заполните данные для регистрации',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Поле email
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Поле пароля
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Подтверждение пароля
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Подтвердите пароль',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock_outline),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Кнопка регистрации
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Ссылка на вход
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Уже есть аккаунт?',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: Text(
                      'Войти',
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
  
  // Функция выхода
  Future<void> _signOut() async {
    try {
      await _supabase.auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выхода: $e')),
      );
    }
  }

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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Выйти',
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
                          '',
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