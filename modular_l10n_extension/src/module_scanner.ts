import * as fs from 'fs';
import * as path from 'path';
import { glob } from 'glob';

export interface ArbFile {
    path: string;
    locale: string;
    moduleName: string;
}

export interface Module {
    name: string;
    path: string;
    arbFiles: ArbFile[];
}

export class ModuleScanner {
    constructor(
        private rootPath: string,
        private arbPattern: string
    ) {}

    async scanModules(): Promise<Module[]> {
        const modules: Map<string, Module> = new Map();

        // Find all ARB files
        const arbFiles = await this.findArbFiles();

        for (const arbFilePath of arbFiles) {
            const parsed = this.parseArbFilePath(arbFilePath);
            if (!parsed) {
                continue;
            }

            const { moduleName, locale, modulePath } = parsed;

            if (!modules.has(moduleName)) {
                modules.set(moduleName, {
                    name: moduleName,
                    path: modulePath,
                    arbFiles: [],
                });
            }

            modules.get(moduleName)!.arbFiles.push({
                path: arbFilePath,
                locale,
                moduleName,
            });
        }

        return Array.from(modules.values());
    }

    private async findArbFiles(): Promise<string[]> {
        return new Promise((resolve, reject) => {
            glob(this.arbPattern, { cwd: this.rootPath, absolute: true }, (err, matches) => {
                if (err) {
                    reject(err);
                } else {
                    // Filter out generated files
                    const filtered = matches.filter(
                        (f) => !f.includes('generated') && !f.includes('.dart_tool')
                    );
                    resolve(filtered);
                }
            });
        });
    }

    private parseArbFilePath(
        arbFilePath: string
    ): { moduleName: string; locale: string; modulePath: string } | null {
        const fileName = path.basename(arbFilePath, '.arb');
        const dirPath = path.dirname(arbFilePath);
        
        // Expected format: moduleName_locale.arb (e.g., auth_en.arb)
        const match = fileName.match(/^(.+)_([a-z]{2}(?:_[A-Z]{2})?)$/);
        
        if (!match) {
            // Try to extract from directory name if file doesn't follow convention
            const parentDir = path.basename(path.dirname(dirPath));
            const localeMatch = fileName.match(/^([a-z]{2}(?:_[A-Z]{2})?)$/);
            if (localeMatch) {
                return {
                    moduleName: parentDir,
                    locale: localeMatch[1],
                    modulePath: path.dirname(dirPath),
                };
            }
            return null;
        }

        return {
            moduleName: match[1],
            locale: match[2],
            modulePath: path.dirname(dirPath),
        };
    }
}
