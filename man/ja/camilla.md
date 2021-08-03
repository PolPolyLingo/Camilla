% CAMILLA(1)
% Naohiro CHIKAMATSU <n.chika156@gmail.com>
% 2021年8月

# 名前

camilla –  Vala言語用の静的解析ツール

# 書式

**camilla** [OPTIONS] DIRECTORY_PATH

# 説明
**camilla**は、任意のディレクトリ以下もしくはカレントディレクトリ以下にある*.valaファイルに対して静的解析します。

# オプション
**-c**, **--count**
:   Vala言語ソースコードの行数（コード行、コメント行、空行）をカウントします。

**-h**, **--help**
:   ヘルプメッセージを表示します。

**-v**, **--version**
:   camillaコマンドのバージョンを表示します。

# 終了ステータス
**0**
:   成功

**1**
:   camillaコマンドの引数指定でエラー

# バグ
GitHub Issuesを参照してください：https://github.com/nao1215/Camilla/issues

# ライセンス
camillaコマンドプロジェクトは、Apache License 2.0条文の下でライセンスされています。