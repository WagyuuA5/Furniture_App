// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/catalog/data/datasources/catalog_remote_datasource.dart'
    as _i248;
import '../../features/catalog/data/repositories/catalog_repository_impl.dart'
    as _i428;
import '../../features/catalog/domain/repositories/catalog_repository.dart'
    as _i1018;
import '../../features/catalog/domain/usecases/get_categories.dart' as _i363;
import '../../features/catalog/domain/usecases/get_products.dart' as _i264;
import '../../providers/product_provider.dart' as _i97;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i248.CatalogRemoteDataSource>(
      () => _i248.CatalogRemoteDataSourceImpl(),
    );
    gh.factory<_i1018.CatalogRepository>(
      () => _i428.CatalogRepositoryImpl(gh<_i248.CatalogRemoteDataSource>()),
    );
    gh.factory<_i363.GetCategories>(
      () => _i363.GetCategories(gh<_i1018.CatalogRepository>()),
    );
    gh.factory<_i264.GetProducts>(
      () => _i264.GetProducts(gh<_i1018.CatalogRepository>()),
    );
    gh.factory<_i97.ProductProvider>(
      () => _i97.ProductProvider(
        gh<_i264.GetProducts>(),
        gh<_i363.GetCategories>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
