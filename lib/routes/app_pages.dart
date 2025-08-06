import 'package:chat_app/controllers/profile_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/views/auth/forgot_password_view.dart';
import 'package:chat_app/views/auth/login_view.dart';
import 'package:chat_app/views/auth/register_view.dart';
import 'package:chat_app/views/profile_view.dart';
import 'package:chat_app/views/splash_view.dart';
import 'package:get/get.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.login, page: ()=>const LoginView()),
    GetPage(name: AppRoutes.register, page: ()=>const RegisterView()),
    GetPage(name: AppRoutes.forgotPassword, page: ()=>const ForgotPasswordView()),
    // GetPage(name: AppRoutes.changePassword, page: ()=>const ChangePasswordView()),
    // GetPage(name: AppRoutes.home, page: ()=>const HomeView()),
    // GetPage(name: AppRoutes.main, page: ()=>const MainView()),
    GetPage(name: AppRoutes.profile, page: ()=>const ProfileView(),binding: BindingsBuilder((){
      Get.put(ProfileController());
    })),
    // GetPage(name: AppRoutes.chat, page: ()=>const ChatView()),
    // GetPage(name: AppRoutes.usersList, page: ()=>const UsersListView()),
    // GetPage(name: AppRoutes.friends, page: ()=>const FriendsView()),
    // GetPage(name: AppRoutes.friendRequests,
    //  page:()=>const FriendRequestsView(),
    // binding: BindingsBuilder((){
    //   Get.put(FriendRequestsController());
    //   })
    //   ),
    // GetPage(name: AppRoutes.notifications, page:()=>const NotificationsView(),
    // binding: BindingsBuilder((){
    //   Get.put(NotificationsController());
    //   })
    // ),
  ];
}
