#!/bin/bash

# Check if feature name is provided
if [ -z "$1" ]; then
    echo "❌ Error: Feature name is required."
    echo "Usage: ./scripts/create_feature.sh <feature_name>"
    exit 1
fi

FEATURE_NAME=$1
BASE_DIR="lib/features/$FEATURE_NAME"

# Check if feature already exists
if [ -d "$BASE_DIR" ]; then
    echo "❌ Error: Feature '$FEATURE_NAME' already exists."
    exit 1
fi

# Function to convert snake_case to PascalCase (macOS compatible)
to_pascal_case() {
    echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS=''
}

# Function to convert snake_case to camelCase (macOS compatible)
to_camel_case() {
    local pascal=$(to_pascal_case "$1")
    echo "$(echo "${pascal:0:1}" | tr '[:upper:]' '[:lower:]')${pascal:1}"
}

PASCAL_NAME=$(to_pascal_case "$FEATURE_NAME")
CAMEL_NAME=$(to_camel_case "$FEATURE_NAME")

echo "🚀 Creating feature: $FEATURE_NAME"
echo "   PascalCase: $PASCAL_NAME"
echo "   camelCase: $CAMEL_NAME"

# Create directory structure
mkdir -p "$BASE_DIR/data/repositories"
mkdir -p "$BASE_DIR/data/datasources"
mkdir -p "$BASE_DIR/data/models"
mkdir -p "$BASE_DIR/domain/entities"
mkdir -p "$BASE_DIR/domain/repositories"
mkdir -p "$BASE_DIR/presentation/pages"
mkdir -p "$BASE_DIR/presentation/widgets"
mkdir -p "$BASE_DIR/presentation/providers"

# Create placeholder entity
cat > "$BASE_DIR/domain/entities/${FEATURE_NAME}_entity.dart" <<EOL
import 'package:flutter/foundation.dart';

/// ${PASCAL_NAME} entity representing the core data model.
@immutable
class ${PASCAL_NAME}Entity {
  /// Creates a [${PASCAL_NAME}Entity] instance.
  const ${PASCAL_NAME}Entity({required this.id});

  /// Unique identifier.
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${PASCAL_NAME}Entity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '${PASCAL_NAME}Entity(id: \$id)';
}
EOL

# Create placeholder repository interface
cat > "$BASE_DIR/domain/repositories/${FEATURE_NAME}_repository.dart" <<EOL
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

import '../entities/${FEATURE_NAME}_entity.dart';

/// Repository interface for ${PASCAL_NAME} feature.
abstract class ${PASCAL_NAME}Repository {
  /// Fetches ${PASCAL_NAME} data.
  Future<Result<${PASCAL_NAME}Entity>> getData();
}
EOL

# Create placeholder repository implementation
cat > "$BASE_DIR/data/repositories/${FEATURE_NAME}_repository_impl.dart" <<EOL
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

import '../../domain/entities/${FEATURE_NAME}_entity.dart';
import '../../domain/repositories/${FEATURE_NAME}_repository.dart';

part '${FEATURE_NAME}_repository_impl.g.dart';

/// Provider for [${PASCAL_NAME}Repository].
@Riverpod(keepAlive: true)
${PASCAL_NAME}Repository ${CAMEL_NAME}Repository(Ref ref) {
  return ${PASCAL_NAME}RepositoryImpl();
}

/// Implementation of [${PASCAL_NAME}Repository].
class ${PASCAL_NAME}RepositoryImpl implements ${PASCAL_NAME}Repository {
  @override
  Future<Result<${PASCAL_NAME}Entity>> getData() async {
    try {
      // TODO: Implement actual data fetching
      return const Success(${PASCAL_NAME}Entity(id: '1'));
    } catch (e) {
      return Failure(UnexpectedException(message: e.toString()));
    }
  }
}
EOL

# Create placeholder provider/notifier
cat > "$BASE_DIR/presentation/providers/${FEATURE_NAME}_notifier.dart" <<EOL
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/${FEATURE_NAME}_repository_impl.dart';
import '../../domain/entities/${FEATURE_NAME}_entity.dart';

part '${FEATURE_NAME}_notifier.g.dart';

/// Notifier for managing ${PASCAL_NAME} state.
@riverpod
class ${PASCAL_NAME}Notifier extends _\$${PASCAL_NAME}Notifier {
  @override
  FutureOr<${PASCAL_NAME}Entity> build() async {
    final repository = ref.watch(${CAMEL_NAME}RepositoryProvider);
    final result = await repository.getData();

    return result.fold(
      onSuccess: (data) => data,
      onFailure: (error) => throw error,
    );
  }

  /// Refresh the data.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(${CAMEL_NAME}RepositoryProvider);
    final result = await repository.getData();

    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (error) => AsyncError(error, StackTrace.current),
    );
  }
}
EOL

# Create placeholder page with HookConsumerWidget and analytics tracking
cat > "$BASE_DIR/presentation/pages/${FEATURE_NAME}_page.dart" <<EOL
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/analytics/analytics_service.dart';
import 'package:riverpod_go_router_boilerplate/core/hooks/hooks.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/async_value_widget.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

import '../providers/${FEATURE_NAME}_notifier.dart';

/// ${PASCAL_NAME} page.
class ${PASCAL_NAME}Page extends HookConsumerWidget {
  /// Creates a [${PASCAL_NAME}Page] instance.
  const ${PASCAL_NAME}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: '${FEATURE_NAME}');
    });

    final state = ref.watch(${CAMEL_NAME}NotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('${PASCAL_NAME}')),
      body: AsyncValueWidget(
        value: state,
        data: (data) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ID: \${data.id}'),
              const VerticalSpace.md(),
              // Add your content here
            ],
          ),
        ),
      ),
    );
  }
}
EOL

# Create barrel file
cat > "$BASE_DIR/${FEATURE_NAME}.dart" <<EOL
/// ${PASCAL_NAME} feature module.
library;

export 'presentation/pages/${FEATURE_NAME}_page.dart';
EOL

echo ""
echo "✅ Feature structure created at $BASE_DIR"
echo ""
echo "📁 Created files:"
echo "   - domain/entities/${FEATURE_NAME}_entity.dart"
echo "   - domain/repositories/${FEATURE_NAME}_repository.dart"
echo "   - data/repositories/${FEATURE_NAME}_repository_impl.dart"
echo "   - presentation/providers/${FEATURE_NAME}_notifier.dart"
echo "   - presentation/pages/${FEATURE_NAME}_page.dart"
echo "   - ${FEATURE_NAME}.dart (barrel file)"
echo ""
echo "👉 Next steps:"
echo "   1. Run 'make gen' to generate providers"
echo "   2. Add route to lib/app/router/app_router.dart"
echo "   3. Implement your feature logic"

