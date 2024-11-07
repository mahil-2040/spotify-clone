import 'package:dartz/dartz.dart';

abstract class UseCase<Types, Params>{
  Future<Either> call({Params params});
}
