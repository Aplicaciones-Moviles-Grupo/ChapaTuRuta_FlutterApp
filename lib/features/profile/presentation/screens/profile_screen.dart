import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/user_provider.dart';
import '../../data/models/user_model.dart';
import '../widgets/profile_option_tile.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color brandBlue = Color.fromRGBO(107, 115, 233, 1);

  @override
  void initState() {
    super.initState();
    // Forzamos la carga del usuario al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: brandBlue));
          }

          // Si el usuario es null (error), mostramos uno temporal para que NO se rompa el diseño
          final user = provider.currentUser ?? UserModel(
            id: '0',
            name: 'Usuario',
            lastName: 'Invitado',
            username: 'guest',
            email: 'Cargando datos...',
            phone: '',
            gender: '',
            favoriteRoutes: [],
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                
                // AVATAR CON IMAGEN
                Stack(
                  children: [
                    Container(
                      width: 100, 
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/chapaturutalogo.png'),
                          fit: BoxFit.cover, 
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: brandBlue, // AZUL
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // DATOS DEL USUARIO
                Text(
                  user.fullName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                
                // BOTÓN EDIT PROFILE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandBlue, // AZUL
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Edit Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // OPCIONES
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ProfileOptionTile(
                        icon: Icons.favorite_border,
                        title: 'Favoritos',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                      ),
                      const Divider(height: 1),
                      ProfileOptionTile(icon: Icons.history, title: 'History', onTap: () {}),
                      const Divider(height: 1),
                      ProfileOptionTile(icon: Icons.settings, title: 'Settings', onTap: () {}),
                      const Divider(height: 1),
                      
                      // LOG OUT
                      ProfileOptionTile(
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cerrar Sesión'),
                              content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: brandBlue),
                                  child: const Text('Cerrar Sesión'),
                                ),
                              ],
                            ),
                          );

                          if (shouldLogout == true && context.mounted) {
                            await context.read<UserProvider>().logout();
                            await context.read<AuthProvider>().logout();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}