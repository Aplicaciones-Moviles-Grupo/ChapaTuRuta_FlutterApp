import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_option_tile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Configuración
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = provider.currentUser;
          if (user == null) {
            return const Center(child: Text('No se pudo cargar el usuario'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.off,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Nombre
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botón Edit Profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Opciones
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ProfileOptionTile(
                        icon: Icons.favorite_border,
                        title: 'Favourites',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tienes ${user.favoriteRoutes.length} rutas favoritas'
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.download_outlined,
                        title: 'Downloads',
                        onTap: () {
                          // Descargas
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.language,
                        title: 'Languages',
                        onTap: () {
                          // Idiomas
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.location_on_outlined,
                        title: 'Location',
                        onTap: () {
                          // Ubicación
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.subscriptions_outlined,
                        title: 'Subscription',
                        onTap: () {
                          // Suscripción
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.display_settings_outlined,
                        title: 'Display',
                        onTap: () {
                          // Display
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.cleaning_services_outlined,
                        title: 'Clear Cache',
                        onTap: () {
                          // Limpiar caché
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Caché limpiado')),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.history,
                        title: 'Clear History',
                        onTap: () {
                          // Limpiar historial
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Historial limpiado')),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                      
                      ProfileOptionTile(
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: () async {
                          await provider.logout();
                          if (context.mounted) {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sesión cerrada')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Versión
                Text(
                  'App Version 2.1',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}