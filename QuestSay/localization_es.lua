if ( GetLocale() == "esES" ) then
-- á \195\161
-- é \195\167
-- í \195\173
-- ó \195\179
-- ú \195\186
-- ñ \195\177

QS_HELPLINE1 = "Usos: "..COLOR_ORANGE.."/qs s|p|g|r T\195\173tulo Misi\195\179n"..COLOR_END.." (s=/decir, p=/grupo, g=/hermandad, r=/banda).";
QS_HELPLINE2 = "        "..COLOR_ORANGE.."/qs T\195\173tulo Misi\195\179n"..COLOR_END.." La salida se selecciona autom\195\161ticamente.";
QS_HELPLINE3 = "        "..COLOR_ORANGE.."/qs"..COLOR_END.." La salida es autom\195\161tica y se coge la misi\195\179n activa en la ventana).";
QS_HELPLINE4 = " CTRL click en el t\195\173tulo de la misi\195\179n funciona como "..COLOR_ORANGE.."/qs"..COLOR_END;

QS_ERRNOQUEST = "No se especific\195\179 una misi\195\179n. Escribe una misi\195\179n o selecci\195\179nala en la ventana.";
QS_ERRQUESTNOTFOUND = "Misi\195\179n '%s' no encontrada.";
QS_ERRQUESTNOOBJ = "La misi\195\179n no tiene objetivos.";

QS_PRINTTITLE = "# Objetivos de \"%s\":";
QS_PRINTDONEPRE = "";
QS_PRINTDONESUF = " (hecho)";
QS_PRINTNOTDONEPRE = "--> ";
QS_PRINTNOTDONESUF = " <--";

QS_LB_OBJECTIVES = "Objetivos";
QS_LB_DESCRIPTION = "Descripci\195\179n";
QS_LB_TEXT = "Texto";
QS_LB_SAY = "Decir";
QS_LB_PARTY = "Grupo";
QS_LB_RAID = "Banda";
QS_LB_GUILD = "Hermandad";
end
