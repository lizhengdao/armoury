/*
* Copyright 2016 Nu-book Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#include "ReadBarcode.h"
#include "TextUtfEncoding.h"
#include "GTIN.h"

#include <windows.h>
#include <shobjidl.h> 

#include <cctype>
#include <chrono>
#include <clocale>
#include <cstring>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#define __STDC_LIB_EXT1__
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

using namespace ZXing;

void zxing_decode(std::string filePath, flutter::EncodableList& results);

void fromImage(const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    flutter::EncodableList imageList;

    // check arguments
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
        auto imageListIt = arguments->find(flutter::EncodableValue("imageList"));
        if (imageListIt != arguments->end()) {
            imageList = std::get<flutter::EncodableList>(imageListIt->second);
        }
    }

    if (imageList.empty()) {
        result->Error("Invalid parameters", nullptr);
        return;
    }

    flutter::EncodableList codeList;
    for (const auto& image : imageList) {
        std::string path = std::get<std::string>(image);
        zxing_decode(path, codeList);
    }

    result->Success(codeList);
}

void zxing_decode(std::string filePath, flutter::EncodableList& codeList) {
    DecodeHints hints;
    hints.setEanAddOnSymbol(EanAddOnSymbol::Read);

    int width, height, channels;
    std::unique_ptr<stbi_uc, void(*)(void*)> buffer(stbi_load(filePath.c_str(), &width, &height, &channels, 4), stbi_image_free);
    if (buffer == nullptr) {
        return;
    }

    ImageView image{ buffer.get(), width, height, ImageFormat::RGBX };
    auto results = ReadBarcodes(image, hints);

    if (results.empty()) {
        results.emplace_back(DecodeStatus::NotFound);
        return;
    }

    for (auto&& result : results) {
        if (result.isValid()) {
            std::string code = TextUtfEncoding::ToUtf8(result.text());
            codeList.push_back(flutter::EncodableValue(code.c_str()));
        }
    }
}
