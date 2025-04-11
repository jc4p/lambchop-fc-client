//
//  Models.swift
//  LambchopCast
//
//  Created by Kasra Rahjerdi on 4/10/25.
//

import Foundation
import SwiftData

struct FeedResponse: Codable {
    let casts: [Cast]
    let next: NextCursor?
}

struct NextCursor: Codable {
    let cursor: String
}

@Model
final class Cast: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: Cast, rhs: Cast) -> Bool {
        lhs.hash == rhs.hash
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }
    
    enum CodingKeys: String, CodingKey {
        case hash, author, app, threadHash = "thread_hash", parentHash = "parent_hash", parentUrl = "parent_url", rootParentUrl = "root_parent_url", parentAuthor = "parent_author", text, timestamp, embeds, channel, reactions, replies, mentionedProfiles = "mentioned_profiles", mentionedProfilesRanges = "mentioned_profiles_ranges", mentionedChannels = "mentioned_channels", mentionedChannelsRanges = "mentioned_channels_ranges", authorChannelContext = "author_channel_context"
    }
    
    var id: String { hash }
    var objectType: String = "cast"
    var hash: String
    var author: Profile?
    var app: Profile?
    var threadHash: String
    var parentHash: String?
    var parentUrl: String?
    var rootParentUrl: String?
    var parentAuthor: ParentAuthor?
    var text: String
    var timestamp: Date
    var embeds: [Embed]?
    var channel: Channel?
    var reactions: Reaction?
    var replies: Reply?
    var mentionedProfiles: [Profile]?
    var mentionedProfilesRanges: [Range]?
    var mentionedChannels: [Channel]?
    var mentionedChannelsRanges: [Range]?
    var authorChannelContext: ChannelContext?
    
    init(hash: String, author: Profile?, app: Profile?, threadHash: String, parentHash: String?, parentUrl: String?, rootParentUrl: String?, parentAuthor: ParentAuthor?, text: String, timestamp: Date, embeds: [Embed]?, channel: Channel?, reactions: Reaction?, replies: Reply?, mentionedProfiles: [Profile]?, mentionedProfilesRanges: [Range]?, mentionedChannels: [Channel]?, mentionedChannelsRanges: [Range]?, authorChannelContext: ChannelContext?) {
        self.hash = hash
        self.author = author
        self.app = app
        self.threadHash = threadHash
        self.parentHash = parentHash
        self.parentUrl = parentUrl
        self.rootParentUrl = rootParentUrl
        self.parentAuthor = parentAuthor
        self.text = text
        self.timestamp = timestamp
        self.embeds = embeds
        self.channel = channel
        self.reactions = reactions
        self.replies = replies
        self.mentionedProfiles = mentionedProfiles
        self.mentionedProfilesRanges = mentionedProfilesRanges
        self.mentionedChannels = mentionedChannels
        self.mentionedChannelsRanges = mentionedChannelsRanges
        self.authorChannelContext = authorChannelContext
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hash = try container.decode(String.self, forKey: .hash)
        author = try container.decodeIfPresent(Profile.self, forKey: .author)
        app = try container.decodeIfPresent(Profile.self, forKey: .app)
        threadHash = try container.decode(String.self, forKey: .threadHash)
        parentHash = try container.decodeIfPresent(String.self, forKey: .parentHash)
        parentUrl = try container.decodeIfPresent(String.self, forKey: .parentUrl)
        rootParentUrl = try container.decodeIfPresent(String.self, forKey: .rootParentUrl)
        parentAuthor = try container.decodeIfPresent(ParentAuthor.self, forKey: .parentAuthor)
        text = try container.decode(String.self, forKey: .text)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: timestampString) {
            timestamp = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Date format is invalid")
        }
        
        embeds = try container.decodeIfPresent([Embed].self, forKey: .embeds)
        channel = try container.decodeIfPresent(Channel.self, forKey: .channel)
        reactions = try container.decodeIfPresent(Reaction.self, forKey: .reactions)
        replies = try container.decodeIfPresent(Reply.self, forKey: .replies)
        mentionedProfiles = try container.decodeIfPresent([Profile].self, forKey: .mentionedProfiles)
        mentionedProfilesRanges = try container.decodeIfPresent([Range].self, forKey: .mentionedProfilesRanges)
        mentionedChannels = try container.decodeIfPresent([Channel].self, forKey: .mentionedChannels)
        mentionedChannelsRanges = try container.decodeIfPresent([Range].self, forKey: .mentionedChannelsRanges)
        authorChannelContext = try container.decodeIfPresent(ChannelContext.self, forKey: .authorChannelContext)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash, forKey: .hash)
        try container.encode(author, forKey: .author)
        try container.encode(app, forKey: .app)
        try container.encode(threadHash, forKey: .threadHash)
        try container.encode(parentHash, forKey: .parentHash)
        try container.encode(parentUrl, forKey: .parentUrl)
        try container.encode(rootParentUrl, forKey: .rootParentUrl)
        try container.encode(parentAuthor, forKey: .parentAuthor)
        try container.encode(text, forKey: .text)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestampString = formatter.string(from: timestamp)
        try container.encode(timestampString, forKey: .timestamp)
        
        try container.encode(embeds, forKey: .embeds)
        try container.encode(channel, forKey: .channel)
        try container.encode(reactions, forKey: .reactions)
        try container.encode(replies, forKey: .replies)
        try container.encode(mentionedProfiles, forKey: .mentionedProfiles)
        try container.encode(mentionedProfilesRanges, forKey: .mentionedProfilesRanges)
        try container.encode(mentionedChannels, forKey: .mentionedChannels)
        try container.encode(mentionedChannelsRanges, forKey: .mentionedChannelsRanges)
        try container.encode(authorChannelContext, forKey: .authorChannelContext)
    }
}

@Model
final class Profile: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case objectType = "object", fid, username, displayName = "display_name", pfpUrl = "pfp_url", custodyAddress = "custody_address", profile, followerCount = "follower_count", followingCount = "following_count", verifications, verifiedAddresses = "verified_addresses", verifiedAccounts = "verified_accounts", powerBadge = "power_badge", bio
    }
    
    var id: String { username ?? String(fid ?? 0) }
    var objectType: String?
    var fid: Int?
    var username: String?
    var displayName: String?
    var pfpUrl: String?
    var custodyAddress: String?
    var profile: ProfileBio?
    var followerCount: Int?
    var followingCount: Int?
    var verifications: [String]?
    var verifiedAddresses: VerifiedAddresses?
    var verifiedAccounts: [VerifiedAccount]?
    var powerBadge: Bool?
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectType = try container.decodeIfPresent(String.self, forKey: .objectType)
        fid = try container.decodeIfPresent(Int.self, forKey: .fid)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        pfpUrl = try container.decodeIfPresent(String.self, forKey: .pfpUrl)
        custodyAddress = try container.decodeIfPresent(String.self, forKey: .custodyAddress)
        profile = try container.decodeIfPresent(ProfileBio.self, forKey: .profile)
        followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount)
        followingCount = try container.decodeIfPresent(Int.self, forKey: .followingCount)
        verifications = try container.decodeIfPresent([String].self, forKey: .verifications)
        verifiedAddresses = try container.decodeIfPresent(VerifiedAddresses.self, forKey: .verifiedAddresses)
        verifiedAccounts = try container.decodeIfPresent([VerifiedAccount].self, forKey: .verifiedAccounts)
        powerBadge = try container.decodeIfPresent(Bool.self, forKey: .powerBadge)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectType, forKey: .objectType)
        try container.encodeIfPresent(fid, forKey: .fid)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(pfpUrl, forKey: .pfpUrl)
        try container.encodeIfPresent(custodyAddress, forKey: .custodyAddress)
        try container.encodeIfPresent(profile, forKey: .profile)
        try container.encodeIfPresent(followerCount, forKey: .followerCount)
        try container.encodeIfPresent(followingCount, forKey: .followingCount)
        try container.encodeIfPresent(verifications, forKey: .verifications)
        try container.encodeIfPresent(verifiedAddresses, forKey: .verifiedAddresses)
        try container.encodeIfPresent(verifiedAccounts, forKey: .verifiedAccounts)
        try container.encodeIfPresent(powerBadge, forKey: .powerBadge)
    }
}

struct ProfileBio: Codable {
    var bio: Bio?
}

struct Bio: Codable {
    var text: String
}

struct ParentAuthor: Codable {
    var fid: Int?
}

struct VerifiedAddresses: Codable {
    var ethAddresses: [String]?
    var solAddresses: [String]?
    var primary: PrimaryAddress?
    
    enum CodingKeys: String, CodingKey {
        case ethAddresses = "eth_addresses"
        case solAddresses = "sol_addresses"
        case primary
    }
}

struct PrimaryAddress: Codable {
    var ethAddress: String?
    var solAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case ethAddress = "eth_address"
        case solAddress = "sol_address"
    }
}

struct VerifiedAccount: Codable {
    var platform: String
    var username: String
}

struct Range: Codable {
    var start: Int
    var end: Int
}

@Model
final class Embed: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case url, metadata, castId = "cast_id", cast
    }
    
    // Use UUID as fallback for embeds without URL
    var id: String { url.isEmpty ? UUID().uuidString : url }
    var url: String = ""
    var metadata: EmbedMetadata?
    var castId: EmbedCastId?
    var embeddedCast: EmbeddedCast?
    
    init(url: String = "", metadata: EmbedMetadata? = nil) {
        self.url = url
        self.metadata = metadata
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle both URL and Cast ID types of embeds
        if container.contains(.url) {
            url = (try? container.decode(String.self, forKey: .url)) ?? ""
            metadata = try? container.decodeIfPresent(EmbedMetadata.self, forKey: .metadata)
        } else if container.contains(.castId) {
            // This is a cast embed, not a URL embed
            castId = try? container.decodeIfPresent(EmbedCastId.self, forKey: .castId)
            embeddedCast = try? container.decodeIfPresent(EmbeddedCast.self, forKey: .cast)
            
            // Generate a URL for identification purposes
            if let hash = castId?.hash {
                url = "https://warpcast.com/~/cast/\(hash)"
            } else {
                url = "cast-embed-\(UUID().uuidString)"
            }
        } else {
            url = "unknown-embed-\(UUID().uuidString)"
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !url.isEmpty {
            try container.encode(url, forKey: .url)
        }
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(castId, forKey: .castId)
        try container.encodeIfPresent(embeddedCast, forKey: .cast)
    }
}

struct EmbedCastId: Codable {
    var fid: Int
    var hash: String
}

@Model
final class EmbeddedCast: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case objectType = "object", hash, author, app, threadHash = "thread_hash", 
             parentHash = "parent_hash", parentUrl = "parent_url", rootParentUrl = "root_parent_url", 
             parentAuthor = "parent_author", text, timestamp, embeds, channel
    }
    
    var id: String { hash }
    var objectType: String?
    var hash: String
    var author: Profile?
    var app: Profile?
    var threadHash: String?
    var parentHash: String?
    var parentUrl: String?
    var rootParentUrl: String?
    var parentAuthor: ParentAuthor?
    var text: String
    var timestamp: Date
    var embeds: [Embed]?
    var channel: Channel?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectType = try container.decodeIfPresent(String.self, forKey: .objectType)
        hash = try container.decode(String.self, forKey: .hash)
        author = try container.decodeIfPresent(Profile.self, forKey: .author)
        app = try container.decodeIfPresent(Profile.self, forKey: .app)
        threadHash = try container.decodeIfPresent(String.self, forKey: .threadHash)
        parentHash = try container.decodeIfPresent(String.self, forKey: .parentHash)
        parentUrl = try container.decodeIfPresent(String.self, forKey: .parentUrl)
        rootParentUrl = try container.decodeIfPresent(String.self, forKey: .rootParentUrl)
        parentAuthor = try container.decodeIfPresent(ParentAuthor.self, forKey: .parentAuthor)
        text = try container.decode(String.self, forKey: .text)
        
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: timestampString) {
            timestamp = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Date format is invalid")
        }
        
        embeds = try container.decodeIfPresent([Embed].self, forKey: .embeds)
        channel = try container.decodeIfPresent(Channel.self, forKey: .channel)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectType, forKey: .objectType)
        try container.encode(hash, forKey: .hash)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(app, forKey: .app)
        try container.encodeIfPresent(threadHash, forKey: .threadHash)
        try container.encodeIfPresent(parentHash, forKey: .parentHash)
        try container.encodeIfPresent(parentUrl, forKey: .parentUrl)
        try container.encodeIfPresent(rootParentUrl, forKey: .rootParentUrl)
        try container.encodeIfPresent(parentAuthor, forKey: .parentAuthor)
        try container.encode(text, forKey: .text)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestampString = formatter.string(from: timestamp)
        try container.encode(timestampString, forKey: .timestamp)
        
        try container.encodeIfPresent(embeds, forKey: .embeds)
        try container.encodeIfPresent(channel, forKey: .channel)
    }
}

struct EmbedMetadata: Codable {
    var contentType: String?
    var contentLength: Int?
    var status: String?
    var image: ImageMetadata?
    var video: VideoMetadata?
    
    enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case contentLength = "content_length"
        case status = "_status"
        case image, video
    }
}

struct ImageMetadata: Codable {
    var widthPx: Int?
    var heightPx: Int?
    
    enum CodingKeys: String, CodingKey {
        case widthPx = "width_px"
        case heightPx = "height_px"
    }
}

struct VideoMetadata: Codable {
    var streams: [VideoStream]?
    var durationS: Double?
    
    enum CodingKeys: String, CodingKey {
        case streams
        case durationS = "duration_s"
    }
}

struct VideoStream: Codable {
    var heightPx: Int?
    var widthPx: Int?
    var codecName: String?
    
    enum CodingKeys: String, CodingKey {
        case heightPx = "height_px"
        case widthPx = "width_px"
        case codecName = "codec_name"
    }
}

@Model
final class Channel: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case objectType = "object", id, name, imageUrl = "image_url"
    }
    
    var objectType: String?
    var id: String
    var name: String?
    var imageUrl: String?
    
    init(id: String, name: String?, imageUrl: String?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectType = try container.decodeIfPresent(String.self, forKey: .objectType)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectType, forKey: .objectType)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
    }
}

@Model
final class Reaction: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case likesCount = "likes_count", recastsCount = "recasts_count", likes, recasts
    }
    
    var id = UUID()
    var likesCount: Int?
    var recastsCount: Int?
    var likes: [User]?
    var recasts: [User]?
    
    init(likesCount: Int?, recastsCount: Int?, likes: [User]?, recasts: [User]?) {
        self.likesCount = likesCount
        self.recastsCount = recastsCount
        self.likes = likes
        self.recasts = recasts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likesCount = try container.decodeIfPresent(Int.self, forKey: .likesCount)
        recastsCount = try container.decodeIfPresent(Int.self, forKey: .recastsCount)
        likes = try container.decodeIfPresent([User].self, forKey: .likes)
        recasts = try container.decodeIfPresent([User].self, forKey: .recasts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(likesCount, forKey: .likesCount)
        try container.encodeIfPresent(recastsCount, forKey: .recastsCount)
        try container.encodeIfPresent(likes, forKey: .likes)
        try container.encodeIfPresent(recasts, forKey: .recasts)
    }
}

struct User: Codable {
    var fid: Int
    var fname: String
}

@Model
final class Reply: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case count
    }
    
    var id = UUID()
    var count: Int?
    
    init(count: Int?) {
        self.count = count
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(count, forKey: .count)
    }
}

struct ChannelContext: Codable {
    var role: String
    var following: Bool
}