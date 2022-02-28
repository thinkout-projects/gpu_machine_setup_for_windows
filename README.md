# WindowsのGPU環境を作る

## 実装

Tensorflowのバージョンが違う場合は、以下のファイル内容を変更する

| ファイル名       | 変更箇所                                       |
| ---------------- | ---------------------------------------------- |
| choco.config     | `<package id="cuda" version="11.2.2.46133" />` |
| install.bat      | `SETX /m CUDA_VER "11.2"`                      |
|                  | `SETX /m CUDA_VER_PATH_NAME "11_2"`            |
| requirements.txt | `tensorflow-gpu==2.5.3`                        |

### 1.CUDNNをダウンロードしておく

#### 1-1.バージョン確認

以下のGPU早見表から対応するTensorflowに必要なCUDNNのバージョンを確認しておく。

> GPU早見表
> https://www.tensorflow.org/install/source?hl=ja#gpu_support_2

#### 1-2.ダウンロード

以下のURLからダウンロードする。

> CUDNNのダウンロード
> https://developer.nvidia.com/rdp/cudnn-archive

### 2.必要な内容をインストールと環境変数を設定

以下の内容が実行されます。

- 環境変数を設定
- chocolateryをインストール
- chocolateryで、`choco.config`ファイルに記載されている内容をインストール
- tensorという仮想環境を作成して`requirements.txt`の内容をインストール

https://blog.kintarou.com/2021/06/25/post-1591/

```batch
rem 実行は管理者権限で実行してください。
.\install.bat
```

### 3.cudnnのインストール

CUDNNのみオフィシャルからダウンロードする必要があるので、別のスクリプトにしている。

```batch
rem 実行は管理者権限で実行してください。
.\cudnn_install.bat
```

### 5.GPUテスト

CUDAが実行できるかどうかをテストする

```batch
.\test.bat
```

## 実行時のエラーのヒント

実行時にエラーが出る場合は以下の内容に気をつける

- 実行ファイルの改行コードがCRLFではない。
- `python`とタイプしてもMicrosoftStoreが起動する場合は、`$PATH`の一番上にPythonのパスが来ていないのが原因。https://stackoverflow.com/questions/58754860/cmd-opens-window-store-when-i-type-python