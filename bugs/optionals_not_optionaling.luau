local semver = {}
semver.__index = semver

type SemverFields = {
    major: number,
    minor: number,
    patch: number,
    metadata: {
        release_candidate: {
            tag: string,
            ver: number,
        }?,
        build: string?,
    }
}

type SemverImpl = typeof(semver)

export type semver = setmetatable<SemverFields, SemverImpl>

function semver.default(): semver
    local fields: SemverFields = {
        major = 0,
        minor = 1,
        patch = 0,
        metadata = {},
    }
    return setmetatable(fields, semver)
end

function semver.from(s: string): semver
    local major, minor, patch = string.match(s, "^(%d+)%.(%d+)%.(%d+)")
    if not major or not minor or not patch then
        -- error("Invalid semver string: " .. s)
        major = tonumber(major)
        minor = tonumber(minor)
        patch = tonumber(patch)
        if not major or not minor or not patch then
            error(`Invalid semver string: {s}`)
        end
    end

    local metadata = {}

    -- Extract release candidate (e.g., -rc.1)
    local rc_name, rc_version = string.match(s, "%-(%a+)%.(%d+)")
    if rc_name and rc_version then
        metadata.release_candidate = {
            tag = rc_name,
            ver = tonumber(rc_version) :: number,
        }
    end

    -- Extract build metadata (e.g., +123)
    local build = string.match(s, "%+([%w%.%-]+)")
    if build then
        metadata.build = build
    end

    assert(
        typeof(major) == "number" 
        and typeof(minor) == "number" 
        and typeof(patch) == "number",
        "Unexpected major/minor/patch"
    )

    local fields: SemverFields = {
        major = major,
        minor = minor,
        patch = patch,
        metadata = metadata, -- LUAU FIXME
        --[[
TypeError: Type
	'{ build: string, release_candidate: { tag: string, ver: number } }'
could not be converted into
	'{ build: string?, release_candidate: { tag: string, ver: number }? }'; 
this is because 
	 * accessing `build` results in `string` and accessing `build` has the 2nd component of the union as `nil`, and `string` is not exactly `nil`
	 * accessing `release_candidate` results in `{ tag: string, ver: number }` and accessing `release_candidate` has the 2nd component of the union as `nil`, and `{ tag: string, ver: number }` is not exactly `nil`L
        ]]
    }

    return setmetatable(fields, semver)
end