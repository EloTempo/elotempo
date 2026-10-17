import { describe, it, expect } from 'vitest';
import type { TipoFonte, GrauConfianca, NovaFonte, NovaCitacao } from './fontes';

describe('Tipos e Estrutura de Fontes e Citações', () => {
  it('cria payload de nova fonte primária com metadados arquivísticos', () => {
    const payload: NovaFonte = {
      titulo: 'Certidão de Casamento de Giuseppi e Maria',
      tipo: 'certidao',
      autor_orgao: '1º Registro Civil das Pessoas Naturais',
      data_publicacao: '1912',
      repositorio: 'Arquivo Público do Estado',
      referencia: 'Livro B-12, Fls. 45v, Termo 890',
      nota: 'Apresenta filiação completa dos cônjuges e testemunhas.',
    };

    expect(payload.titulo).toBe('Certidão de Casamento de Giuseppi e Maria');
    expect(payload.tipo).toBe('certidao');
    expect(payload.repositorio).toBe('Arquivo Público do Estado');
  });

  it('cria payload de citação probatória com grau de certeza', () => {
    const payload: NovaCitacao = {
      fonte_id: 'fnt-12345',
      alvo_tipo: 'pessoa',
      alvo_id: 'p-machado',
      pagina_folha: 'Fls. 12',
      confianca: 'alta',
      transcricao: 'Aos vinte e um dias de junho...',
      nota: 'Registro contemporâneo de batismo.',
    };

    expect(payload.fonte_id).toBe('fnt-12345');
    expect(payload.confianca).toBe('alta');
    expect(payload.alvo_tipo).toBe('pessoa');
  });
});
