





function IS_FAMILY_ARRIA10;
    input[8*20:1] device;
    reg is_arria10;
begin
    if ((device == "Arria 10") || (device == "ARRIA 10") || (device == "arria 10") || (device == "Arria10") || (device == "ARRIA10") || (device == "arria10") || (device == "Arria VI") || (device == "ARRIA VI") || (device == "arria vi") || (device == "ArriaVI") || (device == "ARRIAVI") || (device == "arriavi") || (device == "Night Fury") || (device == "NIGHT FURY") || (device == "night fury") || (device == "nightfury") || (device == "NIGHTFURY") || (device == "Arria 10 (GX/SX/GT)") || (device == "ARRIA 10 (GX/SX/GT)") || (device == "arria 10 (gx/sx/gt)") || (device == "Arria10(GX/SX/GT)") || (device == "ARRIA10(GX/SX/GT)") || (device == "arria10(gx/sx/gt)") || (device == "Arria 10 (GX)") || (device == "ARRIA 10 (GX)") || (device == "arria 10 (gx)") || (device == "Arria10(GX)") || (device == "ARRIA10(GX)") || (device == "arria10(gx)") || (device == "Arria 10 (SX)") || (device == "ARRIA 10 (SX)") || (device == "arria 10 (sx)") || (device == "Arria10(SX)") || (device == "ARRIA10(SX)") || (device == "arria10(sx)") || (device == "Arria 10 (GT)") || (device == "ARRIA 10 (GT)") || (device == "arria 10 (gt)") || (device == "Arria10(GT)") || (device == "ARRIA10(GT)") || (device == "arria10(gt)"))
        is_arria10 = 1;
    else
        is_arria10 = 0;

    IS_FAMILY_ARRIA10  = is_arria10;
end
endfunction //IS_FAMILY_ARRIA10

function IS_FAMILY_ARRIAGX;
    input[8*20:1] device;
    reg is_arriagx;
begin
    if ((device == "Arria GX") || (device == "ARRIA GX") || (device == "arria gx") || (device == "ArriaGX") || (device == "ARRIAGX") || (device == "arriagx") || (device == "Stratix II GX Lite") || (device == "STRATIX II GX LITE") || (device == "stratix ii gx lite") || (device == "StratixIIGXLite") || (device == "STRATIXIIGXLITE") || (device == "stratixiigxlite"))
        is_arriagx = 1;
    else
        is_arriagx = 0;

    IS_FAMILY_ARRIAGX  = is_arriagx;
end
endfunction //IS_FAMILY_ARRIAGX

function IS_FAMILY_ARRIAIIGX;
    input[8*20:1] device;
    reg is_arriaiigx;
begin
    if ((device == "Arria II GX") || (device == "ARRIA II GX") || (device == "arria ii gx") || (device == "ArriaIIGX") || (device == "ARRIAIIGX") || (device == "arriaiigx") || (device == "Arria IIGX") || (device == "ARRIA IIGX") || (device == "arria iigx") || (device == "ArriaII GX") || (device == "ARRIAII GX") || (device == "arriaii gx") || (device == "Arria II") || (device == "ARRIA II") || (device == "arria ii") || (device == "ArriaII") || (device == "ARRIAII") || (device == "arriaii") || (device == "Arria II (GX/E)") || (device == "ARRIA II (GX/E)") || (device == "arria ii (gx/e)") || (device == "ArriaII(GX/E)") || (device == "ARRIAII(GX/E)") || (device == "arriaii(gx/e)") || (device == "PIRANHA") || (device == "piranha"))
        is_arriaiigx = 1;
    else
        is_arriaiigx = 0;

    IS_FAMILY_ARRIAIIGX  = is_arriaiigx;
end
endfunction //IS_FAMILY_ARRIAIIGX

function IS_FAMILY_ARRIAIIGZ;
    input[8*20:1] device;
    reg is_arriaiigz;
begin
    if ((device == "Arria II GZ") || (device == "ARRIA II GZ") || (device == "arria ii gz") || (device == "ArriaII GZ") || (device == "ARRIAII GZ") || (device == "arriaii gz") || (device == "Arria IIGZ") || (device == "ARRIA IIGZ") || (device == "arria iigz") || (device == "ArriaIIGZ") || (device == "ARRIAIIGZ") || (device == "arriaiigz"))
        is_arriaiigz = 1;
    else
        is_arriaiigz = 0;

    IS_FAMILY_ARRIAIIGZ  = is_arriaiigz;
end
endfunction //IS_FAMILY_ARRIAIIGZ

function IS_FAMILY_ARRIAVGZ;
    input[8*20:1] device;
    reg is_arriavgz;
begin
    if ((device == "Arria V GZ") || (device == "ARRIA V GZ") || (device == "arria v gz") || (device == "ArriaVGZ") || (device == "ARRIAVGZ") || (device == "arriavgz"))
        is_arriavgz = 1;
    else
        is_arriavgz = 0;

    IS_FAMILY_ARRIAVGZ  = is_arriavgz;
end
endfunction //IS_FAMILY_ARRIAVGZ

function IS_FAMILY_ARRIAV;
    input[8*20:1] device;
    reg is_arriav;
begin
    if ((device == "Arria V") || (device == "ARRIA V") || (device == "arria v") || (device == "Arria V (GT/GX)") || (device == "ARRIA V (GT/GX)") || (device == "arria v (gt/gx)") || (device == "ArriaV(GT/GX)") || (device == "ARRIAV(GT/GX)") || (device == "arriav(gt/gx)") || (device == "ArriaV") || (device == "ARRIAV") || (device == "arriav") || (device == "Arria V (GT/GX/ST/SX)") || (device == "ARRIA V (GT/GX/ST/SX)") || (device == "arria v (gt/gx/st/sx)") || (device == "ArriaV(GT/GX/ST/SX)") || (device == "ARRIAV(GT/GX/ST/SX)") || (device == "arriav(gt/gx/st/sx)") || (device == "Arria V (GT)") || (device == "ARRIA V (GT)") || (device == "arria v (gt)") || (device == "ArriaV(GT)") || (device == "ARRIAV(GT)") || (device == "arriav(gt)") || (device == "Arria V (GX)") || (device == "ARRIA V (GX)") || (device == "arria v (gx)") || (device == "ArriaV(GX)") || (device == "ARRIAV(GX)") || (device == "arriav(gx)") || (device == "Arria V (ST)") || (device == "ARRIA V (ST)") || (device == "arria v (st)") || (device == "ArriaV(ST)") || (device == "ARRIAV(ST)") || (device == "arriav(st)") || (device == "Arria V (SX)") || (device == "ARRIA V (SX)") || (device == "arria v (sx)") || (device == "ArriaV(SX)") || (device == "ARRIAV(SX)") || (device == "arriav(sx)"))
        is_arriav = 1;
    else
        is_arriav = 0;

    IS_FAMILY_ARRIAV  = is_arriav;
end
endfunction //IS_FAMILY_ARRIAV

function IS_FAMILY_CYCLONE10LP;
    input[8*20:1] device;
    reg is_cyclone10lp;
begin
    if ((device == "Cyclone 10 LP") || (device == "CYCLONE 10 LP") || (device == "cyclone 10 lp") || (device == "cyclone10lp") || (device == "CYCLONE10LP") || (device == "Cyclone10lp") || (device == "CYCLONE10LP") || (device == "cyclone10lp") || (device == "C10LP") || (device == "c10lp") || (device == "Cyclone10LP") || (device == "CYCLONE10LP") || (device == "cyclone10lp"))
        is_cyclone10lp = 1;
    else
        is_cyclone10lp = 0;

    IS_FAMILY_CYCLONE10LP  = is_cyclone10lp;
end
endfunction //IS_FAMILY_CYCLONE10LP

function IS_FAMILY_CYCLONEII;
    input[8*20:1] device;
    reg is_cycloneii;
begin
    if ((device == "Cyclone II") || (device == "CYCLONE II") || (device == "cyclone ii") || (device == "Cycloneii") || (device == "CYCLONEII") || (device == "cycloneii") || (device == "Magellan") || (device == "MAGELLAN") || (device == "magellan") || (device == "CycloneII") || (device == "CYCLONEII") || (device == "cycloneii"))
        is_cycloneii = 1;
    else
        is_cycloneii = 0;

    IS_FAMILY_CYCLONEII  = is_cycloneii;
end
endfunction //IS_FAMILY_CYCLONEII

function IS_FAMILY_CYCLONEIIILS;
    input[8*20:1] device;
    reg is_cycloneiiils;
begin
    if ((device == "Cyclone III LS") || (device == "CYCLONE III LS") || (device == "cyclone iii ls") || (device == "CycloneIIILS") || (device == "CYCLONEIIILS") || (device == "cycloneiiils") || (device == "Cyclone III LPS") || (device == "CYCLONE III LPS") || (device == "cyclone iii lps") || (device == "Cyclone LPS") || (device == "CYCLONE LPS") || (device == "cyclone lps") || (device == "CycloneLPS") || (device == "CYCLONELPS") || (device == "cyclonelps") || (device == "Tarpon") || (device == "TARPON") || (device == "tarpon") || (device == "Cyclone IIIE") || (device == "CYCLONE IIIE") || (device == "cyclone iiie"))
        is_cycloneiiils = 1;
    else
        is_cycloneiiils = 0;

    IS_FAMILY_CYCLONEIIILS  = is_cycloneiiils;
end
endfunction //IS_FAMILY_CYCLONEIIILS

function IS_FAMILY_CYCLONEIII;
    input[8*20:1] device;
    reg is_cycloneiii;
begin
    if ((device == "Cyclone III") || (device == "CYCLONE III") || (device == "cyclone iii") || (device == "CycloneIII") || (device == "CYCLONEIII") || (device == "cycloneiii") || (device == "Barracuda") || (device == "BARRACUDA") || (device == "barracuda") || (device == "Cuda") || (device == "CUDA") || (device == "cuda") || (device == "CIII") || (device == "ciii"))
        is_cycloneiii = 1;
    else
        is_cycloneiii = 0;

    IS_FAMILY_CYCLONEIII  = is_cycloneiii;
end
endfunction //IS_FAMILY_CYCLONEIII

function IS_FAMILY_CYCLONEIVE;
    input[8*20:1] device;
    reg is_cycloneive;
begin
    if ((device == "Cyclone IV E") || (device == "CYCLONE IV E") || (device == "cyclone iv e") || (device == "CycloneIV E") || (device == "CYCLONEIV E") || (device == "cycloneiv e") || (device == "Cyclone IVE") || (device == "CYCLONE IVE") || (device == "cyclone ive") || (device == "CycloneIVE") || (device == "CYCLONEIVE") || (device == "cycloneive"))
        is_cycloneive = 1;
    else
        is_cycloneive = 0;

    IS_FAMILY_CYCLONEIVE  = is_cycloneive;
end
endfunction //IS_FAMILY_CYCLONEIVE

function IS_FAMILY_CYCLONEIVGX;
    input[8*20:1] device;
    reg is_cycloneivgx;
begin
    if ((device == "Cyclone IV GX") || (device == "CYCLONE IV GX") || (device == "cyclone iv gx") || (device == "Cyclone IVGX") || (device == "CYCLONE IVGX") || (device == "cyclone ivgx") || (device == "CycloneIV GX") || (device == "CYCLONEIV GX") || (device == "cycloneiv gx") || (device == "CycloneIVGX") || (device == "CYCLONEIVGX") || (device == "cycloneivgx") || (device == "Cyclone IV") || (device == "CYCLONE IV") || (device == "cyclone iv") || (device == "CycloneIV") || (device == "CYCLONEIV") || (device == "cycloneiv") || (device == "Cyclone IV (GX)") || (device == "CYCLONE IV (GX)") || (device == "cyclone iv (gx)") || (device == "CycloneIV(GX)") || (device == "CYCLONEIV(GX)") || (device == "cycloneiv(gx)") || (device == "Cyclone III GX") || (device == "CYCLONE III GX") || (device == "cyclone iii gx") || (device == "CycloneIII GX") || (device == "CYCLONEIII GX") || (device == "cycloneiii gx") || (device == "Cyclone IIIGX") || (device == "CYCLONE IIIGX") || (device == "cyclone iiigx") || (device == "CycloneIIIGX") || (device == "CYCLONEIIIGX") || (device == "cycloneiiigx") || (device == "Cyclone III GL") || (device == "CYCLONE III GL") || (device == "cyclone iii gl") || (device == "CycloneIII GL") || (device == "CYCLONEIII GL") || (device == "cycloneiii gl") || (device == "Cyclone IIIGL") || (device == "CYCLONE IIIGL") || (device == "cyclone iiigl") || (device == "CycloneIIIGL") || (device == "CYCLONEIIIGL") || (device == "cycloneiiigl") || (device == "Stingray") || (device == "STINGRAY") || (device == "stingray"))
        is_cycloneivgx = 1;
    else
        is_cycloneivgx = 0;

    IS_FAMILY_CYCLONEIVGX  = is_cycloneivgx;
end
endfunction //IS_FAMILY_CYCLONEIVGX

function IS_FAMILY_CYCLONEV;
    input[8*20:1] device;
    reg is_cyclonev;
begin
    if ((device == "Cyclone V") || (device == "CYCLONE V") || (device == "cyclone v") || (device == "CycloneV") || (device == "CYCLONEV") || (device == "cyclonev") || (device == "Cyclone V (GT/GX/E/SX)") || (device == "CYCLONE V (GT/GX/E/SX)") || (device == "cyclone v (gt/gx/e/sx)") || (device == "CycloneV(GT/GX/E/SX)") || (device == "CYCLONEV(GT/GX/E/SX)") || (device == "cyclonev(gt/gx/e/sx)") || (device == "Cyclone V (E/GX/GT/SX/SE/ST)") || (device == "CYCLONE V (E/GX/GT/SX/SE/ST)") || (device == "cyclone v (e/gx/gt/sx/se/st)") || (device == "CycloneV(E/GX/GT/SX/SE/ST)") || (device == "CYCLONEV(E/GX/GT/SX/SE/ST)") || (device == "cyclonev(e/gx/gt/sx/se/st)") || (device == "Cyclone V (E)") || (device == "CYCLONE V (E)") || (device == "cyclone v (e)") || (device == "CycloneV(E)") || (device == "CYCLONEV(E)") || (device == "cyclonev(e)") || (device == "Cyclone V (GX)") || (device == "CYCLONE V (GX)") || (device == "cyclone v (gx)") || (device == "CycloneV(GX)") || (device == "CYCLONEV(GX)") || (device == "cyclonev(gx)") || (device == "Cyclone V (GT)") || (device == "CYCLONE V (GT)") || (device == "cyclone v (gt)") || (device == "CycloneV(GT)") || (device == "CYCLONEV(GT)") || (device == "cyclonev(gt)") || (device == "Cyclone V (SX)") || (device == "CYCLONE V (SX)") || (device == "cyclone v (sx)") || (device == "CycloneV(SX)") || (device == "CYCLONEV(SX)") || (device == "cyclonev(sx)") || (device == "Cyclone V (SE)") || (device == "CYCLONE V (SE)") || (device == "cyclone v (se)") || (device == "CycloneV(SE)") || (device == "CYCLONEV(SE)") || (device == "cyclonev(se)") || (device == "Cyclone V (ST)") || (device == "CYCLONE V (ST)") || (device == "cyclone v (st)") || (device == "CycloneV(ST)") || (device == "CYCLONEV(ST)") || (device == "cyclonev(st)"))
        is_cyclonev = 1;
    else
        is_cyclonev = 0;

    IS_FAMILY_CYCLONEV  = is_cyclonev;
end
endfunction //IS_FAMILY_CYCLONEV

function IS_FAMILY_CYCLONE;
    input[8*20:1] device;
    reg is_cyclone;
begin
    if ((device == "Cyclone") || (device == "CYCLONE") || (device == "cyclone") || (device == "ACEX2K") || (device == "acex2k") || (device == "ACEX 2K") || (device == "acex 2k") || (device == "Tornado") || (device == "TORNADO") || (device == "tornado"))
        is_cyclone = 1;
    else
        is_cyclone = 0;

    IS_FAMILY_CYCLONE  = is_cyclone;
end
endfunction //IS_FAMILY_CYCLONE

function IS_FAMILY_HARDCOPYII;
    input[8*20:1] device;
    reg is_hardcopyii;
begin
    if ((device == "HardCopy II") || (device == "HARDCOPY II") || (device == "hardcopy ii") || (device == "HardCopyII") || (device == "HARDCOPYII") || (device == "hardcopyii") || (device == "Fusion") || (device == "FUSION") || (device == "fusion"))
        is_hardcopyii = 1;
    else
        is_hardcopyii = 0;

    IS_FAMILY_HARDCOPYII  = is_hardcopyii;
end
endfunction //IS_FAMILY_HARDCOPYII

function IS_FAMILY_HARDCOPYIII;
    input[8*20:1] device;
    reg is_hardcopyiii;
begin
    if ((device == "HardCopy III") || (device == "HARDCOPY III") || (device == "hardcopy iii") || (device == "HardCopyIII") || (device == "HARDCOPYIII") || (device == "hardcopyiii") || (device == "HCX") || (device == "hcx"))
        is_hardcopyiii = 1;
    else
        is_hardcopyiii = 0;

    IS_FAMILY_HARDCOPYIII  = is_hardcopyiii;
end
endfunction //IS_FAMILY_HARDCOPYIII

function IS_FAMILY_HARDCOPYIV;
    input[8*20:1] device;
    reg is_hardcopyiv;
begin
    if ((device == "HardCopy IV") || (device == "HARDCOPY IV") || (device == "hardcopy iv") || (device == "HardCopyIV") || (device == "HARDCOPYIV") || (device == "hardcopyiv") || (device == "HardCopy IV (GX)") || (device == "HARDCOPY IV (GX)") || (device == "hardcopy iv (gx)") || (device == "HardCopy IV (E)") || (device == "HARDCOPY IV (E)") || (device == "hardcopy iv (e)") || (device == "HardCopyIV(GX)") || (device == "HARDCOPYIV(GX)") || (device == "hardcopyiv(gx)") || (device == "HardCopyIV(E)") || (device == "HARDCOPYIV(E)") || (device == "hardcopyiv(e)") || (device == "HCXIV") || (device == "hcxiv") || (device == "HardCopy IV (GX/E)") || (device == "HARDCOPY IV (GX/E)") || (device == "hardcopy iv (gx/e)") || (device == "HardCopy IV (E/GX)") || (device == "HARDCOPY IV (E/GX)") || (device == "hardcopy iv (e/gx)") || (device == "HardCopyIV(GX/E)") || (device == "HARDCOPYIV(GX/E)") || (device == "hardcopyiv(gx/e)") || (device == "HardCopyIV(E/GX)") || (device == "HARDCOPYIV(E/GX)") || (device == "hardcopyiv(e/gx)"))
        is_hardcopyiv = 1;
    else
        is_hardcopyiv = 0;

    IS_FAMILY_HARDCOPYIV  = is_hardcopyiv;
end
endfunction //IS_FAMILY_HARDCOPYIV

function IS_FAMILY_MAX10;
    input[8*20:1] device;
    reg is_max10;
begin
    if ((device == "MAX 10") || (device == "max 10") || (device == "MAX 10 FPGA") || (device == "max 10 fpga") || (device == "Zippleback") || (device == "ZIPPLEBACK") || (device == "zippleback") || (device == "MAX10") || (device == "max10") || (device == "MAX 10 (DA/DF/DC/SA/SC)") || (device == "max 10 (da/df/dc/sa/sc)") || (device == "MAX10(DA/DF/DC/SA/SC)") || (device == "max10(da/df/dc/sa/sc)") || (device == "MAX 10 (DA)") || (device == "max 10 (da)") || (device == "MAX10(DA)") || (device == "max10(da)") || (device == "MAX 10 (DF)") || (device == "max 10 (df)") || (device == "MAX10(DF)") || (device == "max10(df)") || (device == "MAX 10 (DC)") || (device == "max 10 (dc)") || (device == "MAX10(DC)") || (device == "max10(dc)") || (device == "MAX 10 (SA)") || (device == "max 10 (sa)") || (device == "MAX10(SA)") || (device == "max10(sa)") || (device == "MAX 10 (SC)") || (device == "max 10 (sc)") || (device == "MAX10(SC)") || (device == "max10(sc)"))
        is_max10 = 1;
    else
        is_max10 = 0;

    IS_FAMILY_MAX10  = is_max10;
end
endfunction //IS_FAMILY_MAX10

function IS_FAMILY_STRATIX10;
    input[8*20:1] device;
    reg is_stratix10;
begin
    if ((device == "Stratix 10") || (device == "STRATIX 10") || (device == "stratix 10") || (device == "Stratix10") || (device == "STRATIX10") || (device == "stratix10") || (device == "nadder") || (device == "NADDER") || (device == "Stratix 10 (GX/SX)") || (device == "STRATIX 10 (GX/SX)") || (device == "stratix 10 (gx/sx)") || (device == "Stratix10(GX/SX)") || (device == "STRATIX10(GX/SX)") || (device == "stratix10(gx/sx)") || (device == "Stratix 10 (GX)") || (device == "STRATIX 10 (GX)") || (device == "stratix 10 (gx)") || (device == "Stratix10(GX)") || (device == "STRATIX10(GX)") || (device == "stratix10(gx)") || (device == "Stratix 10 (SX)") || (device == "STRATIX 10 (SX)") || (device == "stratix 10 (sx)") || (device == "Stratix10(SX)") || (device == "STRATIX10(SX)") || (device == "stratix10(sx)"))
        is_stratix10 = 1;
    else
        is_stratix10 = 0;

    IS_FAMILY_STRATIX10  = is_stratix10;
end
endfunction //IS_FAMILY_STRATIX10

function IS_FAMILY_STRATIXGX;
    input[8*20:1] device;
    reg is_stratixgx;
begin
    if ((device == "Stratix GX") || (device == "STRATIX GX") || (device == "stratix gx") || (device == "Stratix-GX") || (device == "STRATIX-GX") || (device == "stratix-gx") || (device == "StratixGX") || (device == "STRATIXGX") || (device == "stratixgx") || (device == "Aurora") || (device == "AURORA") || (device == "aurora"))
        is_stratixgx = 1;
    else
        is_stratixgx = 0;

    IS_FAMILY_STRATIXGX  = is_stratixgx;
end
endfunction //IS_FAMILY_STRATIXGX

function IS_FAMILY_STRATIXIIGX;
    input[8*20:1] device;
    reg is_stratixiigx;
begin
    if ((device == "Stratix II GX") || (device == "STRATIX II GX") || (device == "stratix ii gx") || (device == "StratixIIGX") || (device == "STRATIXIIGX") || (device == "stratixiigx"))
        is_stratixiigx = 1;
    else
        is_stratixiigx = 0;

    IS_FAMILY_STRATIXIIGX  = is_stratixiigx;
end
endfunction //IS_FAMILY_STRATIXIIGX

function IS_FAMILY_STRATIXII;
    input[8*20:1] device;
    reg is_stratixii;
begin
    if ((device == "Stratix II") || (device == "STRATIX II") || (device == "stratix ii") || (device == "StratixII") || (device == "STRATIXII") || (device == "stratixii") || (device == "Armstrong") || (device == "ARMSTRONG") || (device == "armstrong"))
        is_stratixii = 1;
    else
        is_stratixii = 0;

    IS_FAMILY_STRATIXII  = is_stratixii;
end
endfunction //IS_FAMILY_STRATIXII

function IS_FAMILY_STRATIXIII;
    input[8*20:1] device;
    reg is_stratixiii;
begin
    if ((device == "Stratix III") || (device == "STRATIX III") || (device == "stratix iii") || (device == "StratixIII") || (device == "STRATIXIII") || (device == "stratixiii") || (device == "Titan") || (device == "TITAN") || (device == "titan") || (device == "SIII") || (device == "siii"))
        is_stratixiii = 1;
    else
        is_stratixiii = 0;

    IS_FAMILY_STRATIXIII  = is_stratixiii;
end
endfunction //IS_FAMILY_STRATIXIII

function IS_FAMILY_STRATIXIV;
    input[8*20:1] device;
    reg is_stratixiv;
begin
    if ((device == "Stratix IV") || (device == "STRATIX IV") || (device == "stratix iv") || (device == "TGX") || (device == "tgx") || (device == "StratixIV") || (device == "STRATIXIV") || (device == "stratixiv") || (device == "Stratix IV (GT)") || (device == "STRATIX IV (GT)") || (device == "stratix iv (gt)") || (device == "Stratix IV (GX)") || (device == "STRATIX IV (GX)") || (device == "stratix iv (gx)") || (device == "Stratix IV (E)") || (device == "STRATIX IV (E)") || (device == "stratix iv (e)") || (device == "StratixIV(GT)") || (device == "STRATIXIV(GT)") || (device == "stratixiv(gt)") || (device == "StratixIV(GX)") || (device == "STRATIXIV(GX)") || (device == "stratixiv(gx)") || (device == "StratixIV(E)") || (device == "STRATIXIV(E)") || (device == "stratixiv(e)") || (device == "StratixIIIGX") || (device == "STRATIXIIIGX") || (device == "stratixiiigx") || (device == "Stratix IV (GT/GX/E)") || (device == "STRATIX IV (GT/GX/E)") || (device == "stratix iv (gt/gx/e)") || (device == "Stratix IV (GT/E/GX)") || (device == "STRATIX IV (GT/E/GX)") || (device == "stratix iv (gt/e/gx)") || (device == "Stratix IV (E/GT/GX)") || (device == "STRATIX IV (E/GT/GX)") || (device == "stratix iv (e/gt/gx)") || (device == "Stratix IV (E/GX/GT)") || (device == "STRATIX IV (E/GX/GT)") || (device == "stratix iv (e/gx/gt)") || (device == "StratixIV(GT/GX/E)") || (device == "STRATIXIV(GT/GX/E)") || (device == "stratixiv(gt/gx/e)") || (device == "StratixIV(GT/E/GX)") || (device == "STRATIXIV(GT/E/GX)") || (device == "stratixiv(gt/e/gx)") || (device == "StratixIV(E/GX/GT)") || (device == "STRATIXIV(E/GX/GT)") || (device == "stratixiv(e/gx/gt)") || (device == "StratixIV(E/GT/GX)") || (device == "STRATIXIV(E/GT/GX)") || (device == "stratixiv(e/gt/gx)") || (device == "Stratix IV (GX/E)") || (device == "STRATIX IV (GX/E)") || (device == "stratix iv (gx/e)") || (device == "StratixIV(GX/E)") || (device == "STRATIXIV(GX/E)") || (device == "stratixiv(gx/e)"))
        is_stratixiv = 1;
    else
        is_stratixiv = 0;

    IS_FAMILY_STRATIXIV  = is_stratixiv;
end
endfunction //IS_FAMILY_STRATIXIV

function IS_FAMILY_STRATIXV;
    input[8*20:1] device;
    reg is_stratixv;
begin
    if ((device == "Stratix V") || (device == "STRATIX V") || (device == "stratix v") || (device == "StratixV") || (device == "STRATIXV") || (device == "stratixv") || (device == "Stratix V (GS)") || (device == "STRATIX V (GS)") || (device == "stratix v (gs)") || (device == "StratixV(GS)") || (device == "STRATIXV(GS)") || (device == "stratixv(gs)") || (device == "Stratix V (GT)") || (device == "STRATIX V (GT)") || (device == "stratix v (gt)") || (device == "StratixV(GT)") || (device == "STRATIXV(GT)") || (device == "stratixv(gt)") || (device == "Stratix V (GX)") || (device == "STRATIX V (GX)") || (device == "stratix v (gx)") || (device == "StratixV(GX)") || (device == "STRATIXV(GX)") || (device == "stratixv(gx)") || (device == "Stratix V (GS/GX)") || (device == "STRATIX V (GS/GX)") || (device == "stratix v (gs/gx)") || (device == "StratixV(GS/GX)") || (device == "STRATIXV(GS/GX)") || (device == "stratixv(gs/gx)") || (device == "Stratix V (GS/GT)") || (device == "STRATIX V (GS/GT)") || (device == "stratix v (gs/gt)") || (device == "StratixV(GS/GT)") || (device == "STRATIXV(GS/GT)") || (device == "stratixv(gs/gt)") || (device == "Stratix V (GT/GX)") || (device == "STRATIX V (GT/GX)") || (device == "stratix v (gt/gx)") || (device == "StratixV(GT/GX)") || (device == "STRATIXV(GT/GX)") || (device == "stratixv(gt/gx)") || (device == "Stratix V (GX/GS)") || (device == "STRATIX V (GX/GS)") || (device == "stratix v (gx/gs)") || (device == "StratixV(GX/GS)") || (device == "STRATIXV(GX/GS)") || (device == "stratixv(gx/gs)") || (device == "Stratix V (GT/GS)") || (device == "STRATIX V (GT/GS)") || (device == "stratix v (gt/gs)") || (device == "StratixV(GT/GS)") || (device == "STRATIXV(GT/GS)") || (device == "stratixv(gt/gs)") || (device == "Stratix V (GX/GT)") || (device == "STRATIX V (GX/GT)") || (device == "stratix v (gx/gt)") || (device == "StratixV(GX/GT)") || (device == "STRATIXV(GX/GT)") || (device == "stratixv(gx/gt)") || (device == "Stratix V (GS/GT/GX)") || (device == "STRATIX V (GS/GT/GX)") || (device == "stratix v (gs/gt/gx)") || (device == "Stratix V (GS/GX/GT)") || (device == "STRATIX V (GS/GX/GT)") || (device == "stratix v (gs/gx/gt)") || (device == "Stratix V (GT/GS/GX)") || (device == "STRATIX V (GT/GS/GX)") || (device == "stratix v (gt/gs/gx)") || (device == "Stratix V (GT/GX/GS)") || (device == "STRATIX V (GT/GX/GS)") || (device == "stratix v (gt/gx/gs)") || (device == "Stratix V (GX/GS/GT)") || (device == "STRATIX V (GX/GS/GT)") || (device == "stratix v (gx/gs/gt)") || (device == "Stratix V (GX/GT/GS)") || (device == "STRATIX V (GX/GT/GS)") || (device == "stratix v (gx/gt/gs)") || (device == "StratixV(GS/GT/GX)") || (device == "STRATIXV(GS/GT/GX)") || (device == "stratixv(gs/gt/gx)") || (device == "StratixV(GS/GX/GT)") || (device == "STRATIXV(GS/GX/GT)") || (device == "stratixv(gs/gx/gt)") || (device == "StratixV(GT/GS/GX)") || (device == "STRATIXV(GT/GS/GX)") || (device == "stratixv(gt/gs/gx)") || (device == "StratixV(GT/GX/GS)") || (device == "STRATIXV(GT/GX/GS)") || (device == "stratixv(gt/gx/gs)") || (device == "StratixV(GX/GS/GT)") || (device == "STRATIXV(GX/GS/GT)") || (device == "stratixv(gx/gs/gt)") || (device == "StratixV(GX/GT/GS)") || (device == "STRATIXV(GX/GT/GS)") || (device == "stratixv(gx/gt/gs)") || (device == "Stratix V (GS/GT/GX/E)") || (device == "STRATIX V (GS/GT/GX/E)") || (device == "stratix v (gs/gt/gx/e)") || (device == "StratixV(GS/GT/GX/E)") || (device == "STRATIXV(GS/GT/GX/E)") || (device == "stratixv(gs/gt/gx/e)") || (device == "Stratix V (E)") || (device == "STRATIX V (E)") || (device == "stratix v (e)") || (device == "StratixV(E)") || (device == "STRATIXV(E)") || (device == "stratixv(e)"))
        is_stratixv = 1;
    else
        is_stratixv = 0;

    IS_FAMILY_STRATIXV  = is_stratixv;
end
endfunction //IS_FAMILY_STRATIXV

function IS_FAMILY_STRATIX;
    input[8*20:1] device;
    reg is_stratix;
begin
    if ((device == "Stratix") || (device == "STRATIX") || (device == "stratix") || (device == "Yeager") || (device == "YEAGER") || (device == "yeager"))
        is_stratix = 1;
    else
        is_stratix = 0;

    IS_FAMILY_STRATIX  = is_stratix;
end
endfunction //IS_FAMILY_STRATIX

function FEATURE_FAMILY_CYCLONE;
    input[8*20:1] device;
    reg var_family_cyclone;
begin
    if (IS_FAMILY_CYCLONE(device) )
        var_family_cyclone = 1;
    else
        var_family_cyclone = 0;

    FEATURE_FAMILY_CYCLONE  = var_family_cyclone;
end
endfunction //FEATURE_FAMILY_CYCLONE

function FEATURE_FAMILY_STRATIXIIGX;
    input[8*20:1] device;
    reg var_family_stratixiigx;
begin
    if (IS_FAMILY_STRATIXIIGX(device) || IS_FAMILY_ARRIAGX(device) )
        var_family_stratixiigx = 1;
    else
        var_family_stratixiigx = 0;

    FEATURE_FAMILY_STRATIXIIGX  = var_family_stratixiigx;
end
endfunction //FEATURE_FAMILY_STRATIXIIGX

function FEATURE_FAMILY_STRATIXIII;
    input[8*20:1] device;
    reg var_family_stratixiii;
begin
    if (IS_FAMILY_STRATIXIII(device) || FEATURE_FAMILY_STRATIXIV(device) || FEATURE_FAMILY_HARDCOPYIII(device) )
        var_family_stratixiii = 1;
    else
        var_family_stratixiii = 0;

    FEATURE_FAMILY_STRATIXIII  = var_family_stratixiii;
end
endfunction //FEATURE_FAMILY_STRATIXIII

function FEATURE_FAMILY_ARRIAVGZ;
    input[8*20:1] device;
    reg var_family_arriavgz;
begin
    if (IS_FAMILY_ARRIAVGZ(device) )
        var_family_arriavgz = 1;
    else
        var_family_arriavgz = 0;

    FEATURE_FAMILY_ARRIAVGZ  = var_family_arriavgz;
end
endfunction //FEATURE_FAMILY_ARRIAVGZ

function FEATURE_FAMILY_STRATIXV;
    input[8*20:1] device;
    reg var_family_stratixv;
begin
    if (IS_FAMILY_STRATIXV(device) || FEATURE_FAMILY_ARRIAVGZ(device) )
        var_family_stratixv = 1;
    else
        var_family_stratixv = 0;

    FEATURE_FAMILY_STRATIXV  = var_family_stratixv;
end
endfunction //FEATURE_FAMILY_STRATIXV

function FEATURE_FAMILY_ARRIA10;
    input[8*20:1] device;
    reg var_family_arria10;
begin
    if (IS_FAMILY_ARRIA10(device) || IS_FAMILY_ARRIA10(device) )
        var_family_arria10 = 1;
    else
        var_family_arria10 = 0;

    FEATURE_FAMILY_ARRIA10  = var_family_arria10;
end
endfunction //FEATURE_FAMILY_ARRIA10

function FEATURE_FAMILY_CYCLONE10LP;
    input[8*20:1] device;
    reg var_family_cyclone10lp;
begin
    if (IS_FAMILY_CYCLONE10LP(device) || IS_FAMILY_CYCLONE10LP(device) )
        var_family_cyclone10lp = 1;
    else
        var_family_cyclone10lp = 0;

    FEATURE_FAMILY_CYCLONE10LP  = var_family_cyclone10lp;
end
endfunction //FEATURE_FAMILY_CYCLONE10LP

function FEATURE_FAMILY_STRATIXII;
    input[8*20:1] device;
    reg var_family_stratixii;
begin
    if (IS_FAMILY_STRATIXII(device) || IS_FAMILY_HARDCOPYII(device) || FEATURE_FAMILY_STRATIXIIGX(device) || FEATURE_FAMILY_STRATIXIII(device) )
        var_family_stratixii = 1;
    else
        var_family_stratixii = 0;

    FEATURE_FAMILY_STRATIXII  = var_family_stratixii;
end
endfunction //FEATURE_FAMILY_STRATIXII

function FEATURE_FAMILY_CYCLONEIVGX;
    input[8*20:1] device;
    reg var_family_cycloneivgx;
begin
    if (IS_FAMILY_CYCLONEIVGX(device) || IS_FAMILY_CYCLONEIVGX(device) )
        var_family_cycloneivgx = 1;
    else
        var_family_cycloneivgx = 0;

    FEATURE_FAMILY_CYCLONEIVGX  = var_family_cycloneivgx;
end
endfunction //FEATURE_FAMILY_CYCLONEIVGX

function FEATURE_FAMILY_CYCLONEIVE;
    input[8*20:1] device;
    reg var_family_cycloneive;
begin
    if (IS_FAMILY_CYCLONEIVE(device) || FEATURE_FAMILY_CYCLONE10LP(device) )
        var_family_cycloneive = 1;
    else
        var_family_cycloneive = 0;

    FEATURE_FAMILY_CYCLONEIVE  = var_family_cycloneive;
end
endfunction //FEATURE_FAMILY_CYCLONEIVE

function FEATURE_FAMILY_CYCLONEIII;
    input[8*20:1] device;
    reg var_family_cycloneiii;
begin
    if (IS_FAMILY_CYCLONEIII(device) || IS_FAMILY_CYCLONEIIILS(device) || FEATURE_FAMILY_CYCLONEIVGX(device) || FEATURE_FAMILY_CYCLONEIVE(device) || FEATURE_FAMILY_MAX10(device) || FEATURE_FAMILY_CYCLONE10LP(device) )
        var_family_cycloneiii = 1;
    else
        var_family_cycloneiii = 0;

    FEATURE_FAMILY_CYCLONEIII  = var_family_cycloneiii;
end
endfunction //FEATURE_FAMILY_CYCLONEIII

function FEATURE_FAMILY_CYCLONEII;
    input[8*20:1] device;
    reg var_family_cycloneii;
begin
    if (IS_FAMILY_CYCLONEII(device) || FEATURE_FAMILY_CYCLONEIII(device) )
        var_family_cycloneii = 1;
    else
        var_family_cycloneii = 0;

    FEATURE_FAMILY_CYCLONEII  = var_family_cycloneii;
end
endfunction //FEATURE_FAMILY_CYCLONEII

function FEATURE_FAMILY_STRATIXIV;
    input[8*20:1] device;
    reg var_family_stratixiv;
begin
    if (IS_FAMILY_STRATIXIV(device) || IS_FAMILY_ARRIAIIGX(device) || FEATURE_FAMILY_HARDCOPYIV(device) || FEATURE_FAMILY_STRATIXV(device) || FEATURE_FAMILY_ARRIAV(device) || FEATURE_FAMILY_ARRIAIIGZ(device) || FEATURE_FAMILY_ARRIA10(device) || FEATURE_FAMILY_STRATIX10(device) )
        var_family_stratixiv = 1;
    else
        var_family_stratixiv = 0;

    FEATURE_FAMILY_STRATIXIV  = var_family_stratixiv;
end
endfunction //FEATURE_FAMILY_STRATIXIV

function FEATURE_FAMILY_ARRIAIIGZ;
    input[8*20:1] device;
    reg var_family_arriaiigz;
begin
    if (IS_FAMILY_ARRIAIIGZ(device) )
        var_family_arriaiigz = 1;
    else
        var_family_arriaiigz = 0;

    FEATURE_FAMILY_ARRIAIIGZ  = var_family_arriaiigz;
end
endfunction //FEATURE_FAMILY_ARRIAIIGZ

function FEATURE_FAMILY_HARDCOPYIII;
    input[8*20:1] device;
    reg var_family_hardcopyiii;
begin
    if (IS_FAMILY_HARDCOPYIII(device) || IS_FAMILY_HARDCOPYIII(device) )
        var_family_hardcopyiii = 1;
    else
        var_family_hardcopyiii = 0;

    FEATURE_FAMILY_HARDCOPYIII  = var_family_hardcopyiii;
end
endfunction //FEATURE_FAMILY_HARDCOPYIII

function FEATURE_FAMILY_HARDCOPYIV;
    input[8*20:1] device;
    reg var_family_hardcopyiv;
begin
    if (IS_FAMILY_HARDCOPYIV(device) || IS_FAMILY_HARDCOPYIV(device) )
        var_family_hardcopyiv = 1;
    else
        var_family_hardcopyiv = 0;

    FEATURE_FAMILY_HARDCOPYIV  = var_family_hardcopyiv;
end
endfunction //FEATURE_FAMILY_HARDCOPYIV

function FEATURE_FAMILY_CYCLONEV;
    input[8*20:1] device;
    reg var_family_cyclonev;
begin
    if (IS_FAMILY_CYCLONEV(device) )
        var_family_cyclonev = 1;
    else
        var_family_cyclonev = 0;

    FEATURE_FAMILY_CYCLONEV  = var_family_cyclonev;
end
endfunction //FEATURE_FAMILY_CYCLONEV

function FEATURE_FAMILY_ARRIAV;
    input[8*20:1] device;
    reg var_family_arriav;
begin
    if (IS_FAMILY_ARRIAV(device) || FEATURE_FAMILY_CYCLONEV(device) )
        var_family_arriav = 1;
    else
        var_family_arriav = 0;

    FEATURE_FAMILY_ARRIAV  = var_family_arriav;
end
endfunction //FEATURE_FAMILY_ARRIAV

function FEATURE_FAMILY_MAX10;
    input[8*20:1] device;
    reg var_family_max10;
begin
    if (IS_FAMILY_MAX10(device) )
        var_family_max10 = 1;
    else
        var_family_max10 = 0;

    FEATURE_FAMILY_MAX10  = var_family_max10;
end
endfunction //FEATURE_FAMILY_MAX10

function FEATURE_FAMILY_STRATIX10;
    input[8*20:1] device;
    reg var_family_stratix10;
begin
    if (IS_FAMILY_STRATIX10(device) || IS_FAMILY_STRATIX10(device) )
        var_family_stratix10 = 1;
    else
        var_family_stratix10 = 0;

    FEATURE_FAMILY_STRATIX10  = var_family_stratix10;
end
endfunction //FEATURE_FAMILY_STRATIX10

function FEATURE_FAMILY_HAS_INVERTED_OUTPUT_DDIO;
    input[8*20:1] device;
    reg var_family_has_inverted_output_ddio;
begin
    if (FEATURE_FAMILY_CYCLONEII(device) )
        var_family_has_inverted_output_ddio = 1;
    else
        var_family_has_inverted_output_ddio = 0;

    FEATURE_FAMILY_HAS_INVERTED_OUTPUT_DDIO  = var_family_has_inverted_output_ddio;
end
endfunction //FEATURE_FAMILY_HAS_INVERTED_OUTPUT_DDIO

