<?php

// очистка таблицы b_file от несуществующих файлов
$oRes = \CFile::GetList([]);
while ($dctFile = $oRes->Fetch()) {
    if (!file_exists($_SERVER['DOCUMENT_ROOT'].'/upload/'.$dctFile['SUBDIR'].'/'.$dctFile['FILE_NAME'])) 
            \CFile::Delete($dctFile['ID']);
} 


// очистка таблицы b_file определнного модуя
$oRes = \CFile::GetList([]);
while ($dctFile = $oRes->Fetch()) {
    if (!$dctFile['MODULE_ID']) 
            \CFile::Delete($dctFile['ID']);
}