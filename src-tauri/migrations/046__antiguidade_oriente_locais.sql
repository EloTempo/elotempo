-- 046__antiguidade_oriente_locais.sql
-- Centros milenares da civilização antiga, capitais faraônicas, cidades bíblicas e santuários filosóficos:
-- Mênfis (Egito), Tânis (Egito), Pi-Ramsés (Egito), Hebrom (Canaã), Belém (Judeia), Ur dos Caldeus (Mesopotâmia) e Qufu (China).

INSERT OR IGNORE INTO locais (id, nome, uf, pais_id, latitude, longitude, nome_busca) VALUES
    ('loc-eg-memphis', 'Mênfis (Mit Rahina)', 'Gizé', 'eg', 29.8497, 31.2544, 'menfis mit rahina gize egito antigo faraos piramides imperio antigo'),
    ('loc-eg-tanis', 'Tânis (San el-Hagar)', 'Ash Sharqiyah', 'eg', 30.9767, 31.8817, 'tanis san el hagar delta nilo egito faraos dinastias 21 22 23 tesouro psusennes'),
    ('loc-eg-piramses', 'Pi-Ramsés (Qantir)', 'Ash Sharqiyah', 'eg', 30.7981, 31.8419, 'pi ramses qantir delta nilo egito ramses ii capital ramessida'),
    ('loc-il-hebron', 'Hebrom (Al-Khalil / Macpela)', 'Judeia / Hebron', 'il', 31.5244, 35.1106, 'hebrom hebron macpela canaa israel patriarcas abraao sara isaque jaco'),
    ('loc-il-bethlehem', 'Belém (Beit Lahm)', 'Judeia / Belém', 'il', 31.7054, 35.2024, 'belem bethlehem judeia israel davi jesus natividade nascimento'),
    ('loc-iq-ur', 'Ur dos Caldeus (Tell el-Mukayyar)', 'Dhi Qar', 'iq', 30.9622, 46.1044, 'ur dos caldeus tell el mukayyar mesopotamia sumeria iraque ziggurat berco abraao'),
    ('loc-cn-qufu', 'Qufu', 'Shandong', 'cn', 35.5978, 116.9897, 'qufu shandong china confucio templo de confucio filosofia confucionismo');
