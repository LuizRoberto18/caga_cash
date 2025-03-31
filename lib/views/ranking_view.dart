import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cagada_controller.dart';
import '../data/models/cagada_model.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/widgets/app_bar.dart';

class RankingView extends StatelessWidget {
  final CagadaController _controller = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final userId = _authController.user.value!.uid;
    final userEmail = _authController.user.value!.email;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Ranking de Cagadas',
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: AppColors.primary),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: StreamBuilder<List<CagadaModel>>(
        stream: _controller.getTodasCagadasPublicas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    "Erro ao carregar ranking",
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final todasCagadas = snapshot.data!;
          final ranking = _calcularRanking(todasCagadas);
          // Ordena o ranking pelo número de entupimentos (decrescente)
          final rankingOrdenado = ranking.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final posicaoUsuario = userEmail!.isNotEmpty
              ? rankingOrdenado.indexWhere((entry) => entry.key == userEmail) + 1
              : 0;
          return SingleChildScrollView(
            child: Column(
              children: [
                if (posicaoUsuario > 0)
                  _buildUserPositionCard(posicaoUsuario, ranking[userEmail] ?? 0),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (rankingOrdenado.length >= 3) _buildTopThree(rankingOrdenado),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rankingOrdenado.length,
                        itemBuilder: (context, index) {
                          final entry = rankingOrdenado[index];
                          return _buildRankingItem(
                            index + 1,
                            entry.key,
                            entry.value,
                            entry.key == userEmail,
                          );
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

  Map<String, int> _calcularRanking(List<CagadaModel> cagadas) {
    final ranking = <String, int>{};
    for (final cagada in cagadas.where((c) => c.entupiu)) {
      ranking[cagada.usuarioNome] = (ranking[cagada.usuarioNome] ?? 0) + 1;
    }
    return ranking;
  }

  Widget _buildUserPositionCard(int position, int count) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Sua Posição".toUpperCase(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "#$position",
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.background,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$count ${count == 1 ? 'entupimento' : 'entupimentos'}",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThree(List<MapEntry<String, int>> ranking) {
    return Column(
      children: [
        if (ranking.length > 1) _buildPodiumItem(2, ranking[1].key, ranking[1].value, false),
        if (ranking.isNotEmpty) _buildPodiumItem(1, ranking[0].key, ranking[0].value, true),
        if (ranking.length > 2) _buildPodiumItem(3, ranking[2].key, ranking[2].value, false),
      ],
    );
  }

  Widget _buildPodiumItem(int position, String email, int count, bool isFirst) {
    final height = isFirst ? 120.0 : 80.0;
    final textColor = position == 1 ? AppColors.white : AppColors.text;

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPodiumColor(position),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          if (position == 1)
            Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.3), size: 40),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textColor.withOpacity(position == 1 ? 0.2 : 0.1),
                  ),
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$count ${count == 1 ? 'vez' : 'vezes'}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.emoji_events_rounded,
                  color: _getMedalColor(position),
                  size: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingItem(int position, String email, int count, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: AppColors.primary) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightGrey,
          ),
          child: Text(
            position.toString(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
        title: Text(
          email,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
            color: isCurrentUser ? AppColors.background : AppColors.text,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.textLighter,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma cagada pública encontrada',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quando usuários registrarem cagadas públicas, elas aparecerão aqui',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLighter,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPodiumColor(int position) {
    switch (position) {
      case 1:
        return AppColors.primary;
      case 2:
        return AppColors.secondary;
      case 3:
        return AppColors.accent.withOpacity(0.7);
      default:
        return AppColors.white;
    }
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return AppColors.primary;
    }
  }

  void _showInfoDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sobre o Ranking',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.textLight),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'O ranking mostra os usuários com mais entupimentos registrados em cagadas públicas.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Como funciona:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoItem('Apenas cagadas públicas contam'),
              _buildInfoItem('Somente entupimentos são considerados'),
              _buildInfoItem('Quanto mais entupimentos, maior a posição'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Entendi',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.textLight),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
