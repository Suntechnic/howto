# Блок настроек для root  

```json
    {

        "files.exclude": {
            "**/proc/**": true,
            "**/lost+found/**": true
        },
        "search.exclude": {
            "**/proc/**": true,
            "**/sys/**": true,
            "**/dev/**": true,
            "**/run/**": true,
            "**/var/tmp/**": true,
            "**/tmp/**": true
        },
        "files.watcherExclude": {
            "**/proc/**": true,
            "**/sys/**": true,
            "**/dev/**": true,
            "**/run/**": true,
            "**/var/tmp/**": true,
            "**/tmp/**": true,
            "**/var/cache/**": true
        },
        "search.followSymlinks": false,
        "php.suggest.basic": false,
        "git.enabled": false,
        "remote.extensionKind": {
            "GitHub.copilot": [
                "ui"
            ],
            "GitHub.copilot-chat": [
                "ui"
            ]
        },

        "workbench.colorCustomizations": {
            "activityBar.background": "#4FA600", // бэкграунд панели
            "activityBar.inactiveForeground": "#fff", // фореграунд панели
            "activityBar.activeBackground": "#fff", // бэкграунд активной кнопки
            "activityBar.foreground": "#E30613", // фореграунд активной кнопки и при наведении
        },
    }
```


# Блок настроек для проекта на битрикс

```json
    {

        "files.exclude": {
            "**/bitrix/cache/**": true,
            "**/bitrix/managed_cache/**": true,
            "**/bitrix/stack_cache/**": true,
            "**/bitrix/updates/**": true,
            "**/bitrix/tmp/**": true
        },
        "search.exclude": {
            "**/upload/**": true,
            "**/bitrix/cache/**": true,
            "**/bitrix/managed_cache/**": true,
            "**/bitrix/stack_cache/**": true,
            "**/bitrix/updates/**": true,
            "**/bitrix/tmp/**": true
        },
        "files.watcherExclude": {
            "**/upload/**": true,
            "**/bitrix/cache/**": true,
            "**/bitrix/managed_cache/**": true,
            "**/bitrix/stack_cache/**": true,
            "**/bitrix/updates/**": true,
            "**/bitrix/tmp/**": true
        },
        "intelephense.environment.includePaths": [
            "${workspaceFolder}/bitrix/modules",
            "${workspaceFolder}/local"
        ],
        "intelephense.files.exclude": [
            "**/local/assets/**",
            "**/local/html/**",
            "**/local/.logs/**",
            "**/local/.README/**"
        ],
        "remote.extensionKind": {
            "GitHub.copilot": [
                "ui"
            ],
            "GitHub.copilot-chat": [
                "ui"
            ]
        },

        "workbench.colorCustomizations": {
            "activityBar.background": "#4FA600", // бэкграунд панели
            "activityBar.inactiveForeground": "#fff", // фореграунд панели
            "activityBar.activeBackground": "#fff", // бэкграунд активной кнопки
            "activityBar.foreground": "#E30613", // фореграунд активной кнопки и при наведении
        },
    }
```