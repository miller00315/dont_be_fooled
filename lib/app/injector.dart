import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/application/auth/login_bloc/login_bloc.dart';
import 'package:dont_be_fooled/app/application/auth/sigun_up_bloc/sign_up_bloc.dart';
import 'package:dont_be_fooled/app/application/chat_bloc/chat_bloc.dart';
import 'package:dont_be_fooled/app/application/chat_message_bloc/chat_message_bloc.dart';
import 'package:dont_be_fooled/app/application/splash_bloc/splash_bloc.dart';
import 'package:dont_be_fooled/app/domain/facades/i_app_context_facade.dart';
import 'package:dont_be_fooled/app/domain/facades/i_chat_facade.dart';
import 'package:dont_be_fooled/app/domain/facades/i_login_facade.dart';
import 'package:dont_be_fooled/app/domain/facades/i_splash_facade.dart';
import 'package:dont_be_fooled/app/external/data_sources/app_context_data_source.dart';
import 'package:dont_be_fooled/app/external/data_sources/chat_data_source.dart';
import 'package:dont_be_fooled/app/external/data_sources/login_data_source.dart';
import 'package:dont_be_fooled/app/external/data_sources/splash_data_source.dart';
import 'package:dont_be_fooled/app/external/plugin/receive_whatsap_chat.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_app_context_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_chat_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_login_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_splash_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/facades/app_context_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/facades/chat_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/facades/login_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/facades/splash_facade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';

injectDependencies(GetIt getIt) {
  getIt.registerLazySingleton<ReceiveWhatsAppChat>(
    () => ReceiveWhatsAppChat(),
  );
  getIt.registerLazySingleton<Gemini>(
    () => Gemini.instance,
  );
  getIt.registerLazySingleton<IChatDataSource>(
    () => ChatDataSource(
      getIt.get<Gemini>(),
      getIt.get<ReceiveWhatsAppChat>(),
    ),
  );
  getIt.registerLazySingleton<ILoginDataSource>(
    () => LoginDataSource(getIt.get<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<ISplashDataSource>(
    () => SplashDataSource(getIt.get<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<ILoginFacade>(
    () => LoginFacade(getIt.get<ILoginDataSource>()),
  );
  getIt.registerLazySingleton<IChatFacade>(
    () => ChatFacade(getIt.get<IChatDataSource>()),
  );
  getIt.registerLazySingleton<ISplashFacade>(
    () => SplashFacade(getIt.get<ISplashDataSource>()),
  );
  getIt.registerLazySingleton<IAppContextFacade>(
    () => AppContextFacade(getIt.get<IAppContextDataSource>()),
  );
  getIt.registerLazySingleton<IAppContextDataSource>(
    () => AppContextDataSource(getIt.get<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AppContextBloc>(
    () => AppContextBloc(getIt.get<IAppContextFacade>()),
  );
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(getIt.get<IChatFacade>()),
  );
  getIt.registerFactory<SplashBloc>(
      () => SplashBloc(getIt.get<ISplashFacade>()));
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt.get<ILoginFacade>()),
  );
  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(),
  );
  getIt.registerFactory<ChatMessageBloc>(
    () => ChatMessageBloc(),
  );
}
