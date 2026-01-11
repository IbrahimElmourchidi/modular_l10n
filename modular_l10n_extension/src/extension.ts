import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';
import { ArbParser } from './arb_parser';
import { DartGenerator } from './dart_generator';
import { FileWatcher } from './file_watcher';
import { ModuleScanner } from './module_scanner';

let fileWatcher: FileWatcher | undefined;

export function activate(context: vscode.ExtensionContext) {
    console.log('Modular Flutter L10n extension is now active!');

    const outputChannel = vscode.window.createOutputChannel('Modular L10n');

    // Register generate command
    const generateCommand = vscode.commands.registerCommand(
        'modularL10n.generate',
        async () => {
            await generateTranslations(outputChannel);
        }
    );

    // Register add key command
    const addKeyCommand = vscode.commands.registerCommand(
        'modularL10n.addKey',
        async () => {
            await addTranslationKey(outputChannel);
        }
    );

    // Register create module command
    const createModuleCommand = vscode.commands.registerCommand(
        'modularL10n.createModule',
        async () => {
            await createNewModule(outputChannel);
        }
    );

    context.subscriptions.push(generateCommand, addKeyCommand, createModuleCommand);

    // Start file watcher if enabled
    const config = vscode.workspace.getConfiguration('modularL10n');
    if (config.get<boolean>('watchMode', true)) {
        startFileWatcher(outputChannel);
    }

    // Listen for configuration changes
    vscode.workspace.onDidChangeConfiguration((e) => {
        if (e.affectsConfiguration('modularL10n')) {
            const newConfig = vscode.workspace.getConfiguration('modularL10n');
            if (newConfig.get<boolean>('watchMode', true)) {
                startFileWatcher(outputChannel);
            } else {
                stopFileWatcher();
            }
        }
    });
}

async function generateTranslations(outputChannel: vscode.OutputChannel): Promise<void> {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
        vscode.window.showErrorMessage('No workspace folder found');
        return;
    }

    const rootPath = workspaceFolders[0].uri.fsPath;
    const config = vscode.workspace.getConfiguration('modularL10n');

    outputChannel.appendLine('Starting translation generation...');
    outputChannel.show();

    try {
        // Scan for modules
        const scanner = new ModuleScanner(rootPath, config.get<string>('arbFilePattern', '**/l10n/*.arb'));
        const modules = await scanner.scanModules();

        outputChannel.appendLine(`Found ${modules.length} modules with translations`);

        // Parse ARB files
        const parser = new ArbParser();
        const supportedLocales = config.get<string[]>('supportedLocales', ['en', 'ar']);
        const parsedModules = await parser.parseModules(modules, supportedLocales);

        // Generate Dart code
        const generator = new DartGenerator({
            outputPath: path.join(rootPath, config.get<string>('outputPath', 'lib/generated/l10n')),
            className: config.get<string>('className', 'S'),
            defaultLocale: config.get<string>('defaultLocale', 'en'),
            supportedLocales: supportedLocales,
            generateCombinedArb: config.get<boolean>('generateCombinedArb', true),
        });

        await generator.generate(parsedModules);

        outputChannel.appendLine('Translation generation completed successfully!');
        vscode.window.showInformationMessage('Translations generated successfully!');
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        outputChannel.appendLine(`Error: ${errorMessage}`);
        vscode.window.showErrorMessage(`Failed to generate translations: ${errorMessage}`);
    }
}

async function addTranslationKey(outputChannel: vscode.OutputChannel): Promise<void> {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
        vscode.window.showErrorMessage('No workspace folder found');
        return;
    }

    const rootPath = workspaceFolders[0].uri.fsPath;
    const config = vscode.workspace.getConfiguration('modularL10n');

    // Scan for available modules
    const scanner = new ModuleScanner(rootPath, config.get<string>('arbFilePattern', '**/l10n/*.arb'));
    const modules = await scanner.scanModules();

    if (modules.length === 0) {
        vscode.window.showErrorMessage('No modules with l10n folders found');
        return;
    }

    // Let user select module
    const moduleNames = modules.map(m => m.name);
    const selectedModule = await vscode.window.showQuickPick(moduleNames, {
        placeHolder: 'Select module to add translation key',
    });

    if (!selectedModule) {
        return;
    }

    // Get key name
    const keyName = await vscode.window.showInputBox({
        prompt: 'Enter the translation key name (camelCase)',
        placeHolder: 'e.g., welcomeMessage',
        validateInput: (value) => {
            if (!value || !/^[a-z][a-zA-Z0-9]*$/.test(value)) {
                return 'Key must be camelCase starting with lowercase letter';
            }
            return null;
        },
    });

    if (!keyName) {
        return;
    }

    // Get translations for each locale
    const supportedLocales = config.get<string[]>('supportedLocales', ['en', 'ar']);
    const translations: Record<string, string> = {};

    for (const locale of supportedLocales) {
        const value = await vscode.window.showInputBox({
            prompt: `Enter translation for "${keyName}" in ${locale}`,
            placeHolder: `Translation in ${locale}`,
        });

        if (value === undefined) {
            return; // User cancelled
        }

        translations[locale] = value;
    }

    // Add to ARB files
    const module = modules.find(m => m.name === selectedModule)!;

    for (const locale of supportedLocales) {
        const arbFile = module.arbFiles.find(f => f.locale === locale);
        if (arbFile) {
            try {
                const content = fs.readFileSync(arbFile.path, 'utf-8');
                const arbData = JSON.parse(content);
                arbData[keyName] = translations[locale];
                fs.writeFileSync(arbFile.path, JSON.stringify(arbData, null, 2), 'utf-8');
            } catch (error) {
                outputChannel.appendLine(`Error updating ${arbFile.path}: ${error}`);
            }
        }
    }

    vscode.window.showInformationMessage(`Added key "${keyName}" to ${selectedModule} module`);

    // Regenerate
    await generateTranslations(outputChannel);
}

async function createNewModule(outputChannel: vscode.OutputChannel): Promise<void> {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
        vscode.window.showErrorMessage('No workspace folder found');
        return;
    }

    const rootPath = workspaceFolders[0].uri.fsPath;
    const config = vscode.workspace.getConfiguration('modularL10n');

    // Get module name
    const moduleName = await vscode.window.showInputBox({
        prompt: 'Enter the module name (snake_case)',
        placeHolder: 'e.g., auth, home, settings',
        validateInput: (value) => {
            if (!value || !/^[a-z][a-z0-9_]*$/.test(value)) {
                return 'Module name must be snake_case starting with lowercase letter';
            }
            return null;
        },
    });

    if (!moduleName) {
        return;
    }

    // Get module path
    const modulePath = await vscode.window.showInputBox({
        prompt: 'Enter the module path relative to lib/',
        placeHolder: `e.g., features/${moduleName}`,
        value: `features/${moduleName}`,
    });

    if (!modulePath) {
        return;
    }

    const fullModulePath = path.join(rootPath, 'lib', modulePath);
    const l10nPath = path.join(fullModulePath, 'l10n');

    // Create l10n directory
    fs.mkdirSync(l10nPath, { recursive: true });

    // Create ARB files for each locale
    const supportedLocales = config.get<string[]>('supportedLocales', ['en', 'ar']);

    for (const locale of supportedLocales) {
        const arbContent = {
            '@@locale': locale,
            '@@context': moduleName,
        };

        const arbPath = path.join(l10nPath, `${moduleName}_${locale}.arb`);
        fs.writeFileSync(arbPath, JSON.stringify(arbContent, null, 2), 'utf-8');
    }

    vscode.window.showInformationMessage(`Created module "${moduleName}" with l10n files`);

    // Regenerate
    await generateTranslations(outputChannel);
}

function startFileWatcher(outputChannel: vscode.OutputChannel): void {
    const workspaceFolders = vscode.workspace.workspaceFolders;
    if (!workspaceFolders) {
        return;
    }

    stopFileWatcher();

    const rootPath = workspaceFolders[0].uri.fsPath;
    const config = vscode.workspace.getConfiguration('modularL10n');
    const pattern = config.get<string>('arbFilePattern', '**/l10n/*.arb');

    fileWatcher = new FileWatcher(rootPath, pattern, async () => {
        outputChannel.appendLine('ARB file change detected, regenerating...');
        await generateTranslations(outputChannel);
    });

    fileWatcher.start();
    outputChannel.appendLine('File watcher started');
}

function stopFileWatcher(): void {
    if (fileWatcher) {
        fileWatcher.stop();
        fileWatcher = undefined;
    }
}

export function deactivate() {
    stopFileWatcher();
}
