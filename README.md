# WindowsのGPU環境を作る

Windows上でTensorflow GPUを使用できる環境を、管理者権限で実行するバッチファイルを用いて実装する。

大まかな方法としては、パッケージマネージャのChocolateyを使用してCUDAとminiconda等をインストールし、minicondaをPythonの実行環境にして、必要な環境変数を設定する。

## 必要箇所の書き換え

Tensorflowのバージョンが違う場合は、以下のファイル内容を変更する

| ファイル名       | 変更箇所                                       |
| ---------------- | ---------------------------------------------- |
| choco.config     | `<package id="cuda" version="11.2.2.46133" />` |
| install.bat      | `SETX /m CUDA_VER "11.2"`                      |
|                  | `SETX /m CUDA_VER_PATH_NAME "11_2"`            |
| requirements.txt | `tensorflow-gpu==2.5.3`                        |

## 作業手順

### 1.CUDNNをダウンロードしておく

#### 1-1.バージョン確認

以下のGPU早見表から対応するTensorflowに必要なCUDNNのバージョンを確認しておく。

> GPU早見表
> https://www.tensorflow.org/install/source?hl=ja#gpu_support_2

#### 1-2.ダウンロード

以下のURLから`1-1`で調べたCUDNNのバージョンをダウンロードする。

> CUDNNのダウンロード
> https://developer.nvidia.com/rdp/cudnn-archive

### 2.install.batを管理者権限で実行して必要な内容をインストールと環境変数を設定

以下の内容が実行されます。

- 環境変数をWindowsに設定
- chocolateryをインストール
- chocolateryで、`choco.config`ファイルに記載されている内容をインストール
- tensorという仮想環境を作成して`requirements.txt`の内容をインストール

https://blog.kintarou.com/2021/06/25/post-1591/

```batch
rem 実行は管理者権限で実行してください。
.\install.bat
```

#### このスクリプトを実行することで設定されるシステム環境変数

| 環境変数名                | 内容                                                         |
| ------------------------- | ------------------------------------------------------------ |
| CUDA_ROOT                 | CUDA Tool Kitのインストール先                                |
| CUDA_VER                  | 使用したいCUDAのバージョン番号                               |
| CUDA_VER_PATH_NAME        | CUDA_VERのピリオドをアンダーバーに変更したもの               |
| MINICONDA_PATH            | MINICONDAのインストール先と、各種実行ファイルの設置先パス    |
| PATH                      | MINICONDA_PATHを追記する。                                   |
| CUDA_PATH                 | CUDAが使用する環境変数。インストール時のデフォルトの内容から、CUDA_ROOTとCUDA_VER_PATH_NAMEで指定したものへ変更する。 |
| CUDA_PATH_V{バージョン名} | CUDAが使用する環境変数。インストール時のデフォルトの内容から、CUDA_ROOTを使ったものに変更する。 |
| NVCUDASAMPLES_ROOT        | CUDAが使用する環境変数。CUDA ToolKitのインストール時に設定される |
| NVCUDASAMPLES11_2_ROOT    | CUDAが使用する環境変数。CUDA ToolKitのインストール時に設定される |
| NVTOOLSEXT_PATH           | CUDAが使用する環境変数。CUDA ToolKitのインストール時に設定される |
| ChocolateyInstall         | Chocolateryインストール時に設定される。                      |

#### このスクリプトを実行することで設定されるユーザ環境変数

| 環境変数名               | 内容                                    |
| ------------------------ | --------------------------------------- |
| ChocolateyLastPathUpdate | Chocolateryインストール時に設定される。 |
| ChocolateyToolsLocation  | Chocolateryインストール時に設定される。 |

### 3.cudnn_install.batを管理者権限で実行してcudnnのインストール

`1.`でダウンロードしたCUDNNをインストールする。CUDNNのみオフィシャルからダウンロードする必要があるので、`install.sh`とは別のスクリプトにしている。

```batch
rem 実行は管理者権限で実行してください。
.\cudnn_install.bat
```

### 5.GPUテスト

CUDAが実行できるかどうかをテストする。

```batch
python gpu_test.py
```

## 実行時のエラーのヒント

実行時にエラーが出る場合は以下の内容に気をつける

- 実行ファイルの改行コードがCRLFではない。
- `python`とタイプしてもMicrosoftStoreが起動する場合は、`$PATH`の一番上にPythonのパスが来ていないのが原因。https://stackoverflow.com/questions/58754860/cmd-opens-window-store-when-i-type-python
- `install.bat`を実行すると`---- 'PATH' environment variable exceeds 1024 characters ----`と表示される場合、`PATH`を設定する時にコマンドプロンプトでの文字数制限の上限、1024文字以上になったため`PATH`が設定されない。