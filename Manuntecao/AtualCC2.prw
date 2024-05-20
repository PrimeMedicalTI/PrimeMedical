#INCLUDE "TOTVS.CH"

User Function AtualCC2()
	Local c_Query := ""

	Begin Transaction

// Agrupamento para PORTO VELHO
		c_Query := "Update CC2010 Set CC2_FSRIM = '110001', CC2_FSRIMD = 'PORTO VELHO' " + ;
			"Where R_E_C_N_O_ in (1,2,5,7,9)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para RIO BRANCO
		c_Query := "Update CC2010 Set CC2_FSRIM = '120001', CC2_FSRIMD = 'RIO BRANCO' " + ;
			"Where R_E_C_N_O_ in (64, 65, 66, 67, 68, 69, 70)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para BRASILEIA
		c_Query := "Update CC2010 Set CC2_FSRIM = '120002', CC2_FSRIMD = 'BRASILEIA' " + ;
			"Where R_E_C_N_O_ in (71, 72, 73, 74)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CRUZEIRO DO SUL
		c_Query := "Update CC2010 Set CC2_FSRIM = '120004', CC2_FSRIMD = 'CRUZEIRO DO SUL' " + ;
			"Where R_E_C_N_O_ in (53, 54, 55, 56, 57)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para TARAUACA
		c_Query := "Update CC2010 Set CC2_FSRIM = '120005', CC2_FSRIMD = 'TARAUACA' " + ;
			"Where R_E_C_N_O_ in (58, 59, 60)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SENA MADUREIRA
		c_Query := "Update CC2010 Set CC2_FSRIM = '120003', CC2_FSRIMD = 'SENA MADUREIRA' " + ;
			"Where R_E_C_N_O_ in (61, 62, 63)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para RIO BRANCO
		c_Query := "Update CC2010 Set CC2_FSINT = '1201', CC2_FSINTD = 'RIO BRANCO' " + ;
			"Where R_E_C_N_O_ in (64, 71, 72, 65, 66, 73, 61, 67, 62, 69, 63, 68, 74, 70)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CRUZEIRO DO SUL
		c_Query := "Update CC2010 Set CC2_FSINT = '1202', CC2_FSINTD = 'CRUZEIRO DO SUL' " + ;
			"Where R_E_C_N_O_ in (57, 60, 56, 55, 58, 59, 54, 53)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para DELMIRO GOUVEIA
		c_Query := "Update CC2010 Set CC2_FSRIM = '270009', CC2_FSRIMD = 'DELMIRO GOUVEIA' " + ;
			"Where R_E_C_N_O_ in (1646, 1648, 1649, 1650, 1651, 1652, 1653)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SANTANA DO IPANEMA
		c_Query := "Update CC2010 Set CC2_FSRIM = '270010', CC2_FSRIMD = 'SANTANA DO IPANEMA' " + ;
			"Where R_E_C_N_O_ in (1647, 1654, 1655, 1656, 1657, 1660, 1661, 1663, 1671)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PAO DE ACUCAR - OLHO DAGUA DAS FLORES – BATALHA
		c_Query := "Update CC2010 Set CC2_FSRIM = '270011', CC2_FSRIMD = 'PAO DE ACUCAR - OLHO D'AGUA DAS FLORES – BATALHA' " + ;
			"Where R_E_C_N_O_ in (1658, 1659, 1662, 1664, 1665, 1666, 1669, 1670)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ARAPIRACA
		c_Query := "Update CC2010 Set CC2_FSRIM = '270007', CC2_FSRIMD = 'ARAPIRACA' " + ;
			"Where R_E_C_N_O_ in (1667, 1676, 1682, 1683, 1684, 1685, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 1693, 1695, 1738, 1741)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PALMEIRA DOS INDIOS
		c_Query := "Update CC2010 Set CC2_FSRIM = '270008', CC2_FSRIMD = 'PALMEIRA DOS INDIOS' " + ;
			"Where R_E_C_N_O_ in (1668, 1672, 1673, 1674, 1675, 1678, 1679, 1680, 1681)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ATALAIA
		c_Query := "Update CC2010 Set CC2_FSRIM = '270006', CC2_FSRIMD = 'ATALAIA' " + ;
			"Where R_E_C_N_O_ in (1677, 1696, 1698, 1702, 1703, 1705, 1707)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para UNIAO DOS PALMARES
		c_Query := "Update CC2010 Set CC2_FSRIM = '270005', CC2_FSRIMD = 'UNIAO DOS PALMARES' " + ;
			"Where R_E_C_N_O_ in (1697, 1699, 1700, 1701, 1704, 1715)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PENEDO
		c_Query := "Update CC2010 Set CC2_FSRIM = '270003', CC2_FSRIMD = 'PENEDO' " + ;
			"Where R_E_C_N_O_ in (1694, 1737, 1742, 1743, 1744, 1745, 1746)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PORTO CALVO - SAO LUIS DO QUITUNDE
		c_Query := "Update CC2010 Set CC2_FSRIM = '270002', CC2_FSRIMD = 'PORTO CALVO - SAO LUIS DO QUITUNDE' " + ;
			"Where R_E_C_N_O_ in (1706, 1708, 1710, 1712, 1713, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MACEIO
		c_Query := "Update CC2010 Set CC2_FSRIM = '270001', CC2_FSRIMD = 'MACEIO' " + ;
			"Where R_E_C_N_O_ in (1709, 1711, 1714, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SAO MIGUEL DOS CAMPOS
		c_Query := "Update CC2010 Set CC2_FSRIM = '270004', CC2_FSRIMD = 'SAO MIGUEL DOS CAMPOS' " + ;
			"Where R_E_C_N_O_ in (1734, 1735, 1736, 1739, 1740, 5513)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MACEIO
		c_Query := "Update CC2010 Set CC2_FSINT = '2701', CC2_FSINTD = 'MACEIO' " + ;
			"Where R_E_C_N_O_ in (1677, 1696, 1697, 1698, 1699, 1700, 1701, 1702, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1710, 1711, 1712, 1713, 1714, 1715, 1716, 1717, 1718, 1719, 1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1729, 1730, 1731, 1732, 1733, 1734, 1735, 1736, 1737, 1694, 1739, 1740, 1742, 1743, 1744, 1745, 1746, 5513)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ARAPIRACA
		c_Query := "Update CC2010 Set CC2_FSINT = '2702', CC2_FSINTD = 'ARAPIRACA' " + ;
			"Where R_E_C_N_O_ in (1741, 1695, 1738, 1678, 1679, 1680, 1681, 1682, 1683, 1684, 1685, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 1693, 1646, 1647, 1648, 1649, 1650, 1651, 1652, 1653, 1654, 1655, 1656, 1657, 1658, 1659, 1660, 1661, 1662, 1663, 1664, 1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1674, 1675, 1676)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SAO GABRIEL DA CACHOEIRA
		c_Query := "Update CC2010 Set CC2_FSRIM = '130002', CC2_FSRIMD = 'SAO GABRIEL DA CACHOEIRA' " + ;
			"Where R_E_C_N_O_ in (75, 77, 78)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MANACAPURU
		c_Query := "Update CC2010 Set CC2_FSRIM = '130004', CC2_FSRIMD = 'MANACAPURU' " + ;
			"Where R_E_C_N_O_ in (76, 100, 103, 110)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para TEFE
		c_Query := "Update CC2010 Set CC2_FSRIM = '130005', CC2_FSRIMD = 'TEFE' " + ;
			"Where R_E_C_N_O_ in (79, 80, 84, 85, 90, 96, 97, 98, 99)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para TABATINGA
		c_Query := "Update CC2010 Set CC2_FSRIM = '130006', CC2_FSRIMD = 'TABATINGA' " + ;
			"Where R_E_C_N_O_ in (81, 82, 83, 86, 87, 88, 89)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para EIRUNEPE
		c_Query := "Update CC2010 Set CC2_FSRIM = '130007', CC2_FSRIMD = 'EIRUNEPE' " + ;
			"Where R_E_C_N_O_ in (91, 92, 93, 94, 95)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para COARI
		c_Query := "Update CC2010 Set CC2_FSRIM = '130003', CC2_FSRIMD = 'COARI' " + ;
			"Where R_E_C_N_O_ in (101, 102, 104, 105)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MANAUS
		c_Query := "Update CC2010 Set CC2_FSRIM = '130001', CC2_FSRIMD = 'MANAUS' " + ;
			"Where R_E_C_N_O_ in (106, 107, 108, 109, 111, 112, 113, 114, 117, 133)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ITACOATIARA
		c_Query := "Update CC2010 Set CC2_FSRIM = '130011', CC2_FSRIMD = 'ITACOATIARA' " + ;
			"Where R_E_C_N_O_ in (115, 116, 118, 119, 125, 126)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PARINTINS
		c_Query := "Update CC2010 Set CC2_FSRIM = '130010', CC2_FSRIMD = 'PARINTINS' " + ;
			"Where R_E_C_N_O_ in (120, 121, 122, 123, 124)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para LABREA
		c_Query := "Update CC2010 Set CC2_FSRIM = '130008', CC2_FSRIMD = 'LABREA' " + ;
			"Where R_E_C_N_O_ in (127, 128, 129, 130, 131)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MANICORE
		c_Query := "Update CC2010 Set CC2_FSRIM = '130009', CC2_FSRIMD = 'MANICORE' " + ;
			"Where R_E_C_N_O_ in (132, 134, 135, 136)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MANAUS
		c_Query := "Update CC2010 Set CC2_FSINT = 1301, CC2_FSINTD = 'MANAUS' " + ;
			"Where R_E_C_N_O_ in (75, 76, 77, 78, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 117, 133)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para TEFE
		c_Query := "Update CC2010 Set CC2_FSINT = 1302, CC2_FSINTD = 'TEFE' " + ;
			"Where R_E_C_N_O_ in (79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para LABREA
		c_Query := "Update CC2010 Set CC2_FSINT = 1303, CC2_FSINTD = 'LABREA' " + ;
			"Where R_E_C_N_O_ in (134, 135, 136, 127, 128, 129, 130, 131, 132)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PARINTINS
		c_Query := "Update CC2010 Set CC2_FSINT = 1304, CC2_FSINTD = 'PARINTINS' " + ;
			"Where R_E_C_N_O_ in (118, 119, 120, 121, 122, 123, 124, 125, 126, 115, 116)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para OIAPOQUE
		c_Query := "Update CC2010 Set CC2_FSRIM = 160003, CC2_FSRIMD = 'OIAPOQUE' " + ;
			"Where R_E_C_N_O_ in (295, 296, 297, 298, 299, 302)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PORTO GRANDE
		c_Query := "Update CC2010 Set CC2_FSRIM = 160004, CC2_FSRIMD = 'PORTO GRANDE' " + ;
			"Where R_E_C_N_O_ in (300, 301, 303, 306)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MACAPA
		c_Query := "Update CC2010 Set CC2_FSRIM = 160001, CC2_FSRIMD = 'MACAPA' " + ;
			"Where R_E_C_N_O_ in (304, 305, 307, 309)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para LARANJAL DO JARI
		c_Query := "Update CC2010 Set CC2_FSRIM = 160002, CC2_FSRIMD = 'LARANJAL DO JARI' " + ;
			"Where R_E_C_N_O_ in (308, 310)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para MACAPA
		c_Query := "Update CC2010 Set CC2_FSINT = 1601, CC2_FSINTD = 'MACAPA' " + ;
			"Where R_E_C_N_O_ in (307, 308, 309, 310, 304, 305)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para OIAPOQUE - PORTO GRANDE
		c_Query := "Update CC2010 Set CC2_FSINT = 1602, CC2_FSINTD = 'OIAPOQUE - PORTO GRANDE' " + ;
			"Where R_E_C_N_O_ in (306, 295, 296, 297, 298, 299, 300, 301, 302, 303)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para BARREIRAS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290018, CC2_FSRIMD = 'BARREIRAS' " + ;
			"Where R_E_C_N_O_ in (1822, 1823, 1824, 1825, 1826, 1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834, 1835, 1842, 1844, 5509)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SANTA MARIA DA VITORIA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290019, CC2_FSRIMD = 'SANTA MARIA DA VITORIA' " + ;
			"Where R_E_C_N_O_ in (1836, 1837, 1838, 1839, 1840, 1841, 1843)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para JUAZEIRO
		c_Query := "Update CC2010 Set CC2_FSRIM = 290022, CC2_FSRIMD = 'JUAZEIRO' " + ;
			"Where R_E_C_N_O_ in (1845, 1846, 1847, 1848, 1849, 1850, 1851, 1852, 1965)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PAULO AFONSO
		c_Query := "Update CC2010 Set CC2_FSRIM = 290024, CC2_FSRIMD = 'PAULO AFONSO' " + ;
			"Where R_E_C_N_O_ in (1853, 1854, 1855, 1856, 1857, 1858, 1955)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para XIQUE-XIQUE – BARRA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290021, CC2_FSRIMD = 'XIQUE-XIQUE – BARRA' " + ;
			"Where R_E_C_N_O_ in (1859, 1860, 1861, 1863, 1864, 1865, 1887, 2051, 2055, 2058)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para IRECE
		c_Query := "Update CC2010 Set CC2_FSRIM = 290020, CC2_FSRIMD = 'IRECE' " + ;
			"Where R_E_C_N_O_ in (1862, 1881, 1882, 1883, 1884, 1885, 1886, 1888, 1889, 1891, 1892, 1893, 1894, 1895, 1896, 1897, 1899, 1906, 2064)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para BOM JESUS DA LAPA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290017, CC2_FSRIMD = 'BOM JESUS DA LAPA' " + ;
			"Where R_E_C_N_O_ in (1866, 1869, 1870, 1871, 1869, 2049, 2053, 2056)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para GUANAMBI
		c_Query := "Update CC2010 Set CC2_FSRIM = 290016, CC2_FSRIMD = 'GUANAMBI' " + ;
			"Where R_E_C_N_O_ in (1867, 1868, 2050, 2059, 2109, 2110, 2111, 2112, 2113, 2114, 2115, 2116, 2117, 2118, 2119, 2120, 2121, 2122, 2123, 2124, 2125, 2126, 2132, 2138)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SENHOR DO BONFIM
		c_Query := "Update CC2010 Set CC2_FSRIM = 290023, CC2_FSRIMD = 'SENHOR DO BONFIM' " + ;
			"Where R_E_C_N_O_ in (1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1909)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para JACOBINA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290030, CC2_FSRIMD = 'JACOBINA' " + ;
			"Where R_E_C_N_O_ in (1880, 1900, 1901, 1902, 1903, 1904, 1905, 1907, 1908, 1910, 1911, 1912, 1913, 1914, 1915, 1926)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SEABRA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290034, CC2_FSRIMD = 'SEABRA' " + ;
			"Where R_E_C_N_O_ in (1890, 1898, 2054, 2057, 2063, 2069, 2070, 2072, 2073, 2075)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ITABERABA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290031, CC2_FSRIMD = 'ITABERABA' " + ;
			"Where R_E_C_N_O_ in (1917, 1918, 1919, 1920, 1921, 1925, 2061, 2067, 2071, 2076, 2077, 2096)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para FEIRA DE SANTANA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290029, CC2_FSRIMD = 'FEIRA DE SANTANA' " + ;
			"Where R_E_C_N_O_ in (1916, 1922, 1923, 1924, 1927, 1928, 1929, 1930, 1931, 1932, 1933, 1935, 1936, 1937, 1938, 1940, 1942, 1943, 1944, 1945, 1947, 1948, 1949, 1950, 1982, 1983, 1985, 1986, 1987, 1988, 1989, 1991, 2011)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SANTO ANTONIO DE JESUS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290003, CC2_FSRIMD = 'SANTO ANTONIO DE JESUS' " + ;
			"Where R_E_C_N_O_ in (1934, 2024, 2028, 2033, 2038, 2079, 2081, 2090, 2093, 2097, 2098, 2099, 2102, 2103)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CRUZ DAS ALMAS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290004, CC2_FSRIMD = 'CRUZ DAS ALMAS' " + ;
			"Where R_E_C_N_O_ in (1939, 1946, 2019, 2020, 2021, 2022, 2023, 2025, 2029, 2034, 2035, 2036)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ALAGOINHAS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290002, CC2_FSRIMD = 'ALAGOINHAS' " + ;
			"Where R_E_C_N_O_ in (1941, 1951, 1973, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para JEREMOABO
		c_Query := "Update CC2010 Set CC2_FSRIM = 290028, CC2_FSRIMD = 'JEREMOABO' " + ;
			"Where R_E_C_N_O_ in (1952, 1953, 1954, 1956, 1975)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para EUCLIDES DA CUNHA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290026, CC2_FSRIMD = 'EUCLIDES DA CUNHA' " + ;
			"Where R_E_C_N_O_ in (1957, 1958, 1959, 1960, 1963)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CONCEICAO DO COITE
		c_Query := "Update CC2010 Set CC2_FSRIM = 290032, CC2_FSRIMD = 'CONCEICAO DO COITE' " + ;
			"Where R_E_C_N_O_ in (1961, 1962, 1984, 1990, 1992, 1993, 1996)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para RIBEIRA DO POMBAL
		c_Query := "Update CC2010 Set CC2_FSRIM = 290025, CC2_FSRIMD = 'RIBEIRA DO POMBAL' " + ;
			"Where R_E_C_N_O_ in (1964, 1968, 1970, 1974, 1976, 1978, 1979)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CICERO DANTAS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290027, CC2_FSRIMD = 'CICERO DANTAS' " + ;
			"Where R_E_C_N_O_ in (1966, 1967, 1969, 1971, 1972, 1977)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SERRINHA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290033, CC2_FSRIMD = 'SERRINHA' " + ;
			"Where R_E_C_N_O_ in (1980, 1981, 1994, 1995, 5537)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SALVADOR
		c_Query := "Update CC2010 Set CC2_FSRIM = 290001, CC2_FSRIMD = 'SALVADOR' " + ;
			"Where R_E_C_N_O_ in (2012, 2013, 2014, 2015, 2016, 2017, 2032, 2037, 2039, 2040, 2041, 2043, 2044, 2045, 2046, 2047)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para NAZARE – MARAGOGIPE
		c_Query := "Update CC2010 Set CC2_FSRIM = 290006, CC2_FSRIMD = 'NAZARE – MARAGOGIPE' " + ;
			"Where R_E_C_N_O_ in (2018, 2026, 2027, 2030, 2031, 2042, 2048)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para BRUMADO
		c_Query := "Update CC2010 Set CC2_FSRIM = 290013, CC2_FSRIMD = 'BRUMADO' " + ;
			"Where R_E_C_N_O_ in (2052, 2060, 2068, 2074, 2104, 2105, 2106, 2107, 2108, 2127, 2128, 2135)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para VITORIA DA CONQUISTA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290011, CC2_FSRIMD = 'VITORIA DA CONQUISTA' " + ;
			"Where R_E_C_N_O_ in (2062, 2065, 2066, 2084, 2129, 2130, 2131, 2133, 2134, 2136, 2137, 2139, 2140, 2141, 2142, 2143, 2144, 2145, 2146, 2147, 2148, 2151, 2153, 2154, 2155, 2156, 2157, 2158, 2159)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para JEQUIE
		c_Query := "Update CC2010 Set CC2_FSRIM = 290012, CC2_FSRIMD = 'JEQUIE' " + ;
			"Where R_E_C_N_O_ in (2078, 2080, 2082, 2083, 2085, 2086, 2087, 2088, 2089, 2091, 2092, 2094, 2095, 2100, 2101)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para IPIAU
		c_Query := "Update CC2010 Set CC2_FSRIM = 290014, CC2_FSRIMD = 'IPIAU' " + ;
			"Where R_E_C_N_O_ in (2149, 2173, 2180, 2189, 2190, 2193, 2195, 2198, 2201, 2207, 2212, 2214, 2217)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ILHEUS – ITABUNA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290007, CC2_FSRIMD = 'ILHEUS – ITABUNA' " + ;
			"Where R_E_C_N_O_ in (2150, 2171, 2177, 2179, 2181, 2183, 2185, 2186, 2187, 2188, 2191, 2192, 2194, 2196, 2197, 2199, 2200, 2202, 2204, 2209, 2211, 2213, 2216, 2219)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para CAMACAN
		c_Query := "Update CC2010 Set CC2_FSRIM = 290010, CC2_FSRIMD = 'CAMACAN' " + ;
			"Where R_E_C_N_O_ in (2178, 2184, 2205, 2206, 2208, 2210, 2215)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para EUNAPOLIS - PORTO SEGURO
		c_Query := "Update CC2010 Set CC2_FSRIM = 290009, CC2_FSRIMD = 'EUNAPOLIS - PORTO SEGURO' " + ;
			"Where R_E_C_N_O_ in (2182, 2203, 2220, 2221, 2223, 2224, 2232, 2234)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para TEIXEIRA DE FREITAS
		c_Query := "Update CC2010 Set CC2_FSRIM = 290008, CC2_FSRIMD = 'TEIXEIRA DE FREITAS' " + ;
			"Where R_E_C_N_O_ in (2218, 2219, 2222, 2225, 2226, 2227, 2228, 2229, 2230, 2231, 2233, 2235, 2236)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ITAPETINGA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290015, CC2_FSRIMD = 'ITAPETINGA' " + ;
			"Where R_E_C_N_O_ in (2160, 2161, 2162, 2163, 2164, 2165)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para VALENCA
		c_Query := "Update CC2010 Set CC2_FSRIM = 290005, CC2_FSRIMD = 'VALENCA' " + ;
			"Where R_E_C_N_O_ in (2167, 2168, 2169, 2170, 2172, 2174, 2175, 2176)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SALVADOR
		c_Query := "Update CC2010 Set CC2_FSINT = 2901, CC2_FSINTD = 'SALVADOR' " + ;
			"Where R_E_C_N_O_ in (1941, 1951, 1973, 2012, 2013, 2014, 2015, 2016, 2017, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2032, 2037, 2043, 2044, 2045, 2046, 2047, 2039, 2040, 2041)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para SANTO ANTONIO DE JESUS
		c_Query := "Update CC2010 Set CC2_FSINT = 2902, CC2_FSINTD = 'SANTO ANTONIO DE JESUS' " + ;
			"Where R_E_C_N_O_ in (2042, 2048, 2038, 2033, 2034, 2035, 2036, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030, 2031, 2081, 2079, 2093, 2102, 2103, 2097, 2098, 2099, 1946, 1934, 1939, 2167, 2168, 2169, 2170, 2090, 2172, 2174, 2175, 2176)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para ILHEUS – ITABUNA
		c_Query := "Update CC2010 Set CC2_FSINT = 2903, CC2_FSINTD = 'ILHEUS – ITABUNA' " + ;
			"Where R_E_C_N_O_ in (2177, 2178, 2179, 2171, 2181, 2182, 2183, 2184, 2185, 2186, 2187, 2188, 2191, 2192, 2194, 2196, 2197, 2199, 2200, 2218, 2219, 2220, 2221, 2222, 2223, 2224, 2225, 2226, 2227, 2228, 2229, 2230, 2231, 2232, 2233, 2234, 2235, 2236, 2202, 2203, 2204, 2205, 2206, 2208, 2209, 2210, 2211, 2213, 2215, 2216, 2150)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para VITORIA DA CONQUISTA
		c_Query := "Update CC2010 Set CC2_FSINT = 2904, CC2_FSINTD = 'VITORIA DA CONQUISTA' " + ;
			"Where R_E_C_N_O_ in (2151, 2152, 2153, 2154, 2155, 2156, 2157, 2158, 2159, 2160, 2161, 2162, 2163, 2164, 2165, 2166, 2100, 2101, 2127, 2128, 2129, 2130, 2131, 2139, 2140, 2141, 2142, 2143, 2144, 2145, 2146, 2147, 2148, 2149, 2104, 2105, 2106, 2107, 2108, 2094, 2095, 2080, 2065, 2066, 2082, 2083, 2084, 2085, 2086, 2087, 2088, 2089, 2052, 2060, 2062, 2068, 2074, 2217, 2214, 2078, 2212, 2207, 2201, 2198, 2195, 2193, 2189, 2190, 2133, 2134, 2135, 2136, 2137, 2180, 2173, 2091, 2092)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para GUANAMBI
		c_Query := "Update CC2010 Set CC2_FSINT = 2905, CC2_FSINTD = 'GUANAMBI' " + ;
			"Where R_E_C_N_O_ in (2138, 2059, 2053, 2056, 2049, 2050, 2109, 2110, 2111, 2112, 2113, 2114, 2115, 2116, 2117, 2118, 2119, 2120, 2121, 2122, 2123, 2124, 2125, 2126, 2132, 1866, 1867, 1868, 1869, 1870, 1871)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para BARREIRAS
		c_Query := "Update CC2010 Set CC2_FSINT = 2906, CC2_FSINTD = 'BARREIRAS' " + ;
			"Where R_E_C_N_O_ in (1822, 1823, 1824, 1825, 1826, 1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834, 1835, 1836, 1837, 1838, 1839, 1840, 1841, 1842, 1843, 1844, 5509)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para IRECE
		c_Query := "Update CC2010 Set CC2_FSINT = 2907, CC2_FSINTD = 'IRECE' " + ;
			"Where R_E_C_N_O_ in (1881, 1882, 1883, 1884, 1885, 1886, 1887, 1888, 1889, 1891, 1892, 1893, 1894, 1895, 1896, 1897, 1859, 1860, 1861, 1862, 1863, 1864, 1865, 1899, 1906, 2051, 2064, 2055, 2058)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para JUAZEIRO
		c_Query := "Update CC2010 Set CC2_FSINT = 2908, CC2_FSINTD = 'JUAZEIRO' " + ;
			"Where R_E_C_N_O_ in (1909, 1965, 1872, 1873, 1874, 1875, 1876, 1877, 1878, 1879, 1845, 1846, 1847, 1848, 1849, 1850, 1851, 1852)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para PAULO AFONSO
		c_Query := "Update CC2010 Set CC2_FSINT = 2909, CC2_FSINTD = 'PAULO AFONSO' " + ;
			"Where R_E_C_N_O_ in (1853, 1854, 1855, 1856, 1857, 1858, 1966, 1967, 1968, 1969, 1970, 1971, 1972, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959, 1960, 1974, 1975, 1976, 1977, 1978, 1979, 1963, 1964)"
		n_Erro := TcSqlExec(c_Query)

// Agrupamento para FEIRA DE SANTANA
		c_Query := "Update CC2010 Set CC2_FSINT = 2910, CC2_FSINTD = 'FEIRA DE SANTANA' " + ;
			"Where R_E_C_N_O_ in (2011, 2061, 2063, 2075, 2076, 2077, 2069, 2070, 2071, 2072, 2073, 2057, 2054, 2067, 2096, 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1961, 1962, 1910, 1911, 1912, 1913, 1914, 1915, 1916, 1917, 1918, 1919, 1920, 1921, 1922, 1923, 1924, 1925, 1926, 1927, 1928, 1929, 1930, 1931, 1932, 1933, 1907, 1908, 1940, 1935, 1936, 1937, 1938, 1947, 1948, 1949, 1950, 1942, 1943, 1944, 1945, 1880, 1890, 1900, 1901, 1902, 1903, 1904, 1905, 1898, 5537)"
		n_Erro := TcSqlExec(c_Query)




		//Se houve erro, mostra a mensagem e cancela a transação
		If n_Erro != 0
			MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
			DisarmTransaction()
		Else
			l_AtuNotas := .T.
			MsgAlert("Terminou Estados", "Atenção")
		EndIf
	End Transaction

Return()
