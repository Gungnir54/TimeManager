import eslint from '@eslint/js';
import eslintPluginVue from 'eslint-plugin-vue';
import tseslint from 'typescript-eslint';

export default [
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.vue'],
    plugins: {
      vue: eslintPluginVue,
    },
    rules: {
      ...eslintPluginVue.configs.base.rules,
      ...eslintPluginVue.configs['vue3-essential'].rules,
    },
    env: {
      node: true,
    },
  },
  {
    ignores: ['.gitignore'],
  },
  {
    rules: {
      'no-console': 'off',
      'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    },
  }
];
