<?php

// удаление модулей
global $step;
$lstModules4Uninstall = [
        'blog' => ['deleteemails' => 'Y'],
        'form' => [],
        'b24connector' => [],
        'mobileapp' => [],
        'bitrixcloud' => [],
        'clouds' => [],
        'vote' => [],
        'landing' => [],
        'messageservice' => [],
        'socialservices' => [],
        'scale' => [],
        'forum' => [],
        'photogallery' => [],

        // 'translate' => [],
        // 'location' => [],
        // 'search' => [],
        // 'seo' => [],
    ];
$dctRequestLast = [];
foreach ($lstModules4Uninstall as $ModuleId=>$dctRequest) {
    
    // засираем шаг
    $step = 2;
    $_GET['step'] = 2;
    $_REQUEST['step'] = 2;

    $module = \CModule::CreateModuleObject($ModuleId);
    if ($module && $module->IsInstalled()) {
        foreach(\GetModuleEvents('main', 'OnModuleInstalled', true) as $arEvent) {
            \ExecuteModuleEventEx($arEvent, array($ModuleId));
        }

        foreach ($dctRequestLast as $Key=>$_) {
            unset($_REQUEST[$Key]);
        }
        foreach ($dctRequest as $Key=>$Val) {
            $_REQUEST[$Key] = $Val;
        }
        $dctRequestLast = $dctRequest;

        $module->DoUninstall();
    }
}


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