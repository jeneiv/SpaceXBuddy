//
//  CDLaunchLink+Extensions.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 29..
//

import Foundation
import CoreData

extension CDLaunchLink {
    static func from(_ links: SpaceXBuddy.Launch.Links, in context: NSManagedObjectContext) -> CDLaunchLink {
        let cdLaunchLink = CDLaunchLink(context: context)
        cdLaunchLink.webcast = links.webcast
        cdLaunchLink.wikipedia = links.wikipedia
        cdLaunchLink.patch = CDLaunchPatch.from(links.patch, in: context)
        cdLaunchLink.reddit = CDLaunchRedditLink.from(links.reddit, in: context)
        cdLaunchLink.flickr = CDLaunchFlickrLink.from(links.flickr, in: context)
        return cdLaunchLink
    }
}

extension CDLaunchPatch {
    static func from(_ patch: SpaceXBuddy.Launch.Patch, in context: NSManagedObjectContext) -> CDLaunchPatch {
        let cdLaunchPatch = CDLaunchPatch(context: context)
        cdLaunchPatch.small = patch.small
        cdLaunchPatch.large = patch.large
        return cdLaunchPatch
    }
}

extension CDLaunchRedditLink {
    static func from(_ redditLinks: SpaceXBuddy.Launch.RedditLinks, in context: NSManagedObjectContext) -> CDLaunchRedditLink {
        let cdLaunchRedditLink = CDLaunchRedditLink(context: context)
        cdLaunchRedditLink.campaign = redditLinks.campaign
        cdLaunchRedditLink.launch = redditLinks.launch
        cdLaunchRedditLink.media = redditLinks.media
        cdLaunchRedditLink.recovery = redditLinks.recovery
        return cdLaunchRedditLink
    }
}

extension CDLaunchFlickrLink {
    static func from(_ flickrLinks : SpaceXBuddy.Launch.FlickrLinks, in context: NSManagedObjectContext) -> CDLaunchFlickrLink {
        let cdLaunchFlickrLink = CDLaunchFlickrLink(context: context)
        cdLaunchFlickrLink.original = flickrLinks.original
        cdLaunchFlickrLink.small = flickrLinks.small
        return cdLaunchFlickrLink
    }
}
