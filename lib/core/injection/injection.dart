import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/features/todo/data/datasource/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/datasource/todo_local_datasource_impl.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';
import 'package:todo_app/features/todo/data/repository/todo_repository_impl.dart';
import 'package:todo_app/features/todo/domain/repository/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/get_todos_usecase.dart';
import 'package:todo_app/features/todo/domain/usecase/update_todo_usecase.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // hive
  final box = await Hive.openBox<TodoModel>('todos');

  sl.registerLazySingleton<Box<TodoModel>>(
    () => box,
  );

  // datasource
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(
      sl(),
    ),
  );

  // repo
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      sl(),
    ),
  );

  // usecase
  sl.registerLazySingleton(
    () => AddTodoUsecase(sl()),
  );

  sl.registerLazySingleton(
    () => DeleteTodoUsecase(sl()),
  );

  sl.registerLazySingleton(
    () => GetTodosUsecase(sl()),
  );

  sl.registerLazySingleton(
    () => UpdateTodoUsecase(sl()),
  );

  // bloc
  sl.registerFactory(
    () => TodoBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}
