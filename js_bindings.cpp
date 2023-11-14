#include <string>

#include "./bitcoin/script/miniscript.h"

#include "compiler.h"

namespace {

using miniscript::operator"" _mst;

void Output(const std::string& str, char* out, int outlen) {
    int maxlen = std::min<int>(outlen - 1, str.size());
    memcpy(out, str.c_str(), maxlen);
    out[maxlen] = 0;
}

std::string Props(const miniscript::NodeRef<std::string>& node, std::string in) {
    std::string ret = "<span title=\"type: ";
    if (node->GetType() == ""_mst) {
        ret += "[invalid]";
    } else {
        if (node->GetType() << "B"_mst) ret += 'B';
        if (node->GetType() << "V"_mst) ret += 'V';
        if (node->GetType() << "W"_mst) ret += 'W';
        if (node->GetType() << "K"_mst) ret += 'K';
        if (node->GetType() << "z"_mst) ret += 'z';
        if (node->GetType() << "o"_mst) ret += 'o';
        if (node->GetType() << "n"_mst) ret += 'n';
        if (node->GetType() << "d"_mst) ret += 'd';
        if (node->GetType() << "f"_mst) ret += 'f';
        if (node->GetType() << "e"_mst) ret += 'e';
        if (node->GetType() << "m"_mst) ret += 'm';
        if (node->GetType() << "u"_mst) ret += 'u';
        if (node->GetType() << "s"_mst) ret += 's';
        if (node->GetType() << "k"_mst) ret += 'k';
    }
    ret += "&#13;scriptlen: " + std::to_string(node->ScriptSize());
    ret += "&#13;max ops: " + std::to_string(node->GetOps());
    ret += "&#13;max stack size: " + std::to_string(node->GetStackSize());
    return std::move(ret) + "\">" + std::move(in) + "</span>";
}

std::string Analyze(const miniscript::NodeRef<std::string>& node) {
    switch (node->fragment) {
        case miniscript::Fragment::PK_K: {
            return Props(node, "pk_k(" + (*COMPILER_CTX.ToString(node->keys[0])) + ")");
        }
        case miniscript::Fragment::PK_H: {
            return Props(node, "pk_h(" + (*COMPILER_CTX.ToString(node->keys[0])) + ")");
        }
        case miniscript::Fragment::MULTI: return Props(node, "multi(" + std::to_string(node->k) + " of " + std::to_string(node->keys.size()) + ")");
        case miniscript::Fragment::AFTER: return Props(node, "after(" + std::to_string(node->k) + ")");
        case miniscript::Fragment::OLDER: return Props(node, "older(" + std::to_string(node->k) + ")");
        case miniscript::Fragment::SHA256: return Props(node, "sha256()");
        case miniscript::Fragment::RIPEMD160: return Props(node, "ripemd160()");
        case miniscript::Fragment::HASH256: return Props(node, "hash256()");
        case miniscript::Fragment::HASH160: return Props(node, "hash160()");
        case miniscript::Fragment::JUST_0: return Props(node, "false");
        case miniscript::Fragment::JUST_1: return Props(node, "true");
        case miniscript::Fragment::WRAP_A: return Props(node, "a:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_S: return Props(node, "s:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_C: return Props(node, "c:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_D: return Props(node, "d:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_V: return Props(node, "v:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_N: return Props(node, "n:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::WRAP_J: return Props(node, "j:") + " " + Analyze(node->subs[0]);
        case miniscript::Fragment::AND_V: return Props(node, "and_v") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::AND_B: return Props(node, "and_b") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::OR_B: return Props(node, "or_b") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::OR_C: return Props(node, "or_c") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::OR_D: return Props(node, "or_d") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::OR_I: return Props(node, "or_i") + "<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul>";
        case miniscript::Fragment::ANDOR: return Props(node, "andor [or]") + "<ul style=\"list-style-type: disc;\"><li>andor [and]<ul style=\"list-style-type: disc;\"><li>" + Analyze(node->subs[0]) + "</li><li>" + Analyze(node->subs[1]) + "</li></ul></li><li>" + Analyze(node->subs[2]) + "</li></ul>";
        case miniscript::Fragment::THRESH: {
             auto ret = Props(node, "thresh(" + std::to_string(node->k) + " of " + std::to_string(node->subs.size()) + ")") + "<ul style=\"list-style-type: disc;\">";
             for (const auto& sub : node->subs) {
                 ret += "<li>" + Analyze(sub) + "</li>";
             }
             return std::move(ret) + "</ul>";
        }
    }
}

}

extern "C" {

void miniscript_compile(const char* desc, char* msout, int msoutlen, char* costout, int costoutlen, char* asmout, int asmoutlen) {
    try {
        std::string str(desc);
        str.erase(str.find_last_not_of(" \n\r\t") + 1);
        miniscript::NodeRef<std::string> ret;
        double avgcost;
        if (!Compile(Expand(str), ret, avgcost)) {
            Output("[compile error]", msout, msoutlen);
            Output("[compile error]", costout, costoutlen);
            Output("[compile error]", asmout, asmoutlen);
            return;
        }
        Output(Abbreviate(*(ret->ToString(COMPILER_CTX))), msout, msoutlen);
        std::string coststr = "<ul><li>Script: " + std::to_string(ret->ScriptSize()) + " WU</li><li>Input: " + std::to_string(avgcost) + " WU</li><li>Total: " + std::to_string(ret->ScriptSize() + avgcost) + " WU</li></ul>";
        Output(coststr, costout, costoutlen);
        Output(Disassemble(ret->ToScript(COMPILER_CTX)), asmout, asmoutlen);
    } catch (const std::exception& e) {
        Output("[exception: " + std::string(e.what()) + "]", msout, msoutlen);
        Output("", costout, costoutlen);
        Output("", asmout, asmoutlen);
    }
}

void miniscript_analyze(const char* ms, char* costout, int costoutlen, char* asmout, int asmoutlen) {
    try {
        std::string str(ms);
        str.erase(str.find_last_not_of(" \n\r\t") + 1);
        miniscript::NodeRef<std::string> ret;
        ret = miniscript::FromString(Expand(str), COMPILER_CTX);
        if (!ret || !ret->IsValidTopLevel()) {
            Output("[analysis error]", costout, costoutlen);
            Output("[analysis error]", asmout, asmoutlen);
            return;
        }
        std::string coststr = "Size: " + std::to_string(ret->ScriptSize()) + " bytes script<ul><li>" + Analyze(ret) + "</li></ul>";
        Output(coststr, costout, costoutlen);
        Output(Disassemble(ret->ToScript(COMPILER_CTX)), asmout, asmoutlen);
    } catch (const std::exception& e) {
        Output("[exception: " + std::string(e.what()) + "]", costout, costoutlen);
        Output("", asmout, asmoutlen);
    }
}

}
