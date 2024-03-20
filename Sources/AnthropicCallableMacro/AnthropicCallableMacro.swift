//
//  AnthropicCallableMacro.swift
//
//
//  Created by 伊藤史 on 2024/03/20.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// 指定されたstatic functionを実装するclassに対してClaudeのFunction Calling互換なxmlを返すプロパティを追加する
///
/// Function Callingに渡すxmlは
/// - tool_description: 親ノード
///     - tool_name: 関数名
///     - description: 関数の簡単な説明...先頭から最初の空行まで
///     - parameters: パラメーターの配列
///         - name: パラメーター名
///         - type: パラメーターの型
///         - description: パラメーターの詳細...存在する場合、parameter X: の後に続く行もしくはparametersから下にある `- x:` が含まれる行
public struct AnthropicCallable: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let lt = node.leadingTrivia
        switch lt {
        case .docBlockComment(let text):
            print(text)
            break
        default:
            break
        }

        return []
    }
    
    /// Analyzes the doc comment to return the description of the function as a string
    ///
    /// - Parameter docComment: doc comment of the function to analyze
    /// - Returns: the description of the function
    static func getFunctionDescription(from docComment: String) -> String {
        let docCommentLines = docComment.split(separator: "\n", omittingEmptySubsequences: false)

        var splitIndex = docCommentLines.count - 1
        for (index, line) in docCommentLines.enumerated() {
            if line.hasSuffix("///") {
                splitIndex = index
                break
            }
        }

        return docCommentLines[...splitIndex].joined(separator: "\n")
    }
    
    /// Analyzes the doc comment to return the description of the specified function parameter as a string
    ///
    /// - Parameters:
    ///   - parameterName: name of parameter to analyze
    ///   - docComment: doc comment of the function to analyze
    /// - Returns: the description of the parameter
    static func getArgumentDescription(for parameterName: String, from docComment: String) -> String {
        let docCommentLines = docComment.split(separator: "\n", omittingEmptySubsequences: false)

        var commentDescription = ""
        for line in docCommentLines {
            if line.contains("- \(parameterName): ") {
                commentDescription = line.replacingOccurrences(of: "- \(parameterName): ", with: "").replacingOccurrences(of: " ", with: "")
                break
            }

            if line.contains("- Parameter \(parameterName): ") {
                commentDescription = line.replacingOccurrences(of: "- Parameter \(parameterName): ", with: "").replacingOccurrences(of: " ", with: "")
                break
            }
        }

        return commentDescription
    }
}
