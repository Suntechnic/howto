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



// ловец шаблонов

if (defined('APPLICATION_ENV') && APPLICATION_ENV == 'dev') {
    $lstFiles = get_included_files();
    
    $lstTemplateFiles = array_filter($lstFiles,function ($File) {return !!strpos($File,'/template.php');});

    $lstTemplateFiles = array_map(function ($File) {
            $lstToken = explode('/',$File);
            $lstReverseToken = array_reverse($lstToken);

            
            if ($lstReverseToken[2] == 'lang') {
                $dctFile = [
                        'patch' => $File,
                        'template' => $lstReverseToken[3],
                        'component' => $lstReverseToken[4],
                        'lang' => true
                    ];
            } else {
                $dctFile = [
                        'patch' => $File,
                        'template' => $lstReverseToken[1],
                        'component' => $lstReverseToken[2]
                    ];
            }

            return $dctFile;
        }, $lstTemplateFiles);

    foreach ($lstTemplateFiles as $dctFile) { if ($dctFile['lang']) continue;
        $Template = $dctFile['component'].':'.$dctFile['template'];
        \Kint\Kint::dump($Template,$dctFile);
    }
}
