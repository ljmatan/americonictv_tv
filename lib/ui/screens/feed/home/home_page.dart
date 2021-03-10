import 'package:americonictv_tv/ui/shared/video_entry_button.dart';
import 'package:flutter/material.dart';
import 'package:americonictv_tv/logic/api/models/videos_response_model.dart';
import 'package:americonictv_tv/logic/api/videos.dart';
import 'package:americonictv_tv/ui/screens/feed/home/latest_entry.dart';
import 'package:americonictv_tv/ui/shared/future_no_data.dart';

class HomePage extends StatelessWidget {
  static final Future<VideosResponse> _getLatest = VideosAPI.getLatest();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLatest,
      builder: (context, AsyncSnapshot<VideosResponse> videos) =>
          videos.connectionState != ConnectionState.done ||
                  videos.hasError ||
                  videos.hasData && videos.data.error != false ||
                  videos.hasData && videos.data.response.rows.isEmpty
              ? FutureBuilderNoData(videos)
              : Column(
                  children: [
                    const SizedBox(height: 6),
                    if (videos.data.response.rows.length < 8)
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 16 / 10,
                        ),
                        itemCount: videos.data.response.rows.length,
                        itemBuilder: (context, i) => VideoEntryButton(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          video: videos.data.response.rows[i],
                          padding: EdgeInsets.fromLTRB(
                            (i + 1) % 3 == 0 ? 0 : 12,
                            6,
                            i % 3 == 0 ? 0 : 12,
                            6,
                          ),
                        ),
                      )
                    else
                      for (var i = 2; i >= 0; i--)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: LatestEntry(
                                  video: videos.data.response.rows[i * 3],
                                  index: 0,
                                ),
                              ),
                              Expanded(
                                child: LatestEntry(
                                  video: videos.data.response.rows[i * 3 + 1],
                                  index: 1,
                                ),
                              ),
                              Expanded(
                                child: LatestEntry(
                                  video: i * 3 + 2 < 8
                                      ? videos.data.response.rows[i * 3 + 2]
                                      : null,
                                  index: 2,
                                ),
                              ),
                            ].reversed.toList(),
                          ),
                        ),
                    const SizedBox(height: 6),
                  ],
                ),
    );
  }
}
